<?php

///////////////////////////////////////////////////////////////////////
// Copyright 2007, Wiebe Cazemier, Rowan Rodrik van der Molen
//
// This program is free software: you can redistribute it and/or modify
// it under the terms of the GNU General Public License as published by
// the Free Software Foundation, either version 3 of the License, or
// (at your option) any later version.
//
// This program is distributed in the hope that it will be useful,
// but WITHOUT ANY WARRANTY; without even the implied warranty of
// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
// GNU General Public License for more details.
//
// You should have received a copy of the GNU General Public License
// along with this program.  If not, see <http://www.gnu.org/licenses/>.
//
///////////////////////////////////////////////////////////////////////


// My MySQL functions. These are supposed to make working with MySQL more convenient.

function mymysql_build_query($query)
{
  if ( is_string($query) )
    $generated_sql = $query;
  elseif ( is_array($query) )
  {
    $generated_sql = $query[0];

    foreach($query[1] as $key => $value)
    {
      if ( is_string($value) )
        $value = "'".mysql_real_escape_string($value)."'";

      // Replace the :keys with the values
      $generated_sql = preg_replace("/:$key\b/", " $value ", $generated_sql);
    }
  }

  return $generated_sql;
}

function mymysql_where($where)
{
  if ( is_null($where) ) return '';

  $sql .= "WHERE ";

  // TODO: Look up primary key in information_schema
  if ( is_int($where) ) {
    $sql .= "id = $where";
  }
  else
  {
    $sql .= mymysql_build_query($where);
  }

  return $sql;
}

function mymysql_select($query)
{
  $generated_sql = mymysql_build_query($query);
  $result = mysql_query($generated_sql);

  if (!$result) trigger_error("mysql_query() failed: " . mysql_error(), E_USER_ERROR);

  $rows = array();
  while ($row = mysql_fetch_assoc($result)) $rows[] = $row;

  return $rows;
}

function mymysql_select_one($query)
{
  $rows = mymysql_select($query);

  return $rows[0];
}

function mymysql_select_value($query)
{
  $generated_sql = mymysql_build_query($query);
  $result = mysql_query($generated_sql);

  if (!$result) trigger_error("mysql_query() failed: " . mysql_error(), E_USER_ERROR);

  $row = mysql_fetch_array($result);

  if ( isset($row[0]) )
    return $row[0];
  else
    return null;
}

function mymysql_insert($table_name, $row)
{
  $column_names = array();
  $column_values = array();

  $sql = "INSERT INTO $table_name (";

  foreach ($row as $column_name => $column_value)
  {
    $column_names[] = $column_name;
    $column_values[] = "'" . mysql_real_escape_string($column_value) . "'";
  }

  $sql .= implode(', ', $column_names) . ") VALUES (" . implode(', ', $column_values) . ")";

  if ( !mysql_query($sql) ) trigger_error("mysql_query() failed: " . mysql_error(), E_USER_ERROR);

  return mysql_insert_id();
}

function mymysql_delete($table_name, $where)
{
  $sql = "DELETE FROM $table_name " . mymysql_where($where);

  if ( !mysql_query($sql) ) trigger_error("mysql_query() failed: " . mysql_error(), E_USER_ERROR);

  return mysql_affected_rows();
}

function mymysql_update($table_name, $where, $row_update)
{
  $updated_columns = array();

  $sql = "UPDATE $table_name SET ";

  foreach ($row_update as $column_name => $column_value) 
  {
    if ( is_string($column_value) )
      $column_value = "'" . mysql_real_escape_string($column_value) . "'";

    $updated_columns[] = sprintf("%s = %s", $column_name, $column_value);
  }

  $sql .= implode(', ', $updated_columns) . " " . mymysql_where($where);

  if ( !mysql_query($sql) ) trigger_error("mysql_query() failed: " . mysql_error(), E_USER_ERROR);

  return mysql_affected_rows();
}

function mymysql_begin_transaction()
{
  mysql_query('BEGIN');
}

function mymysql_commit_transaction()
{
  mysql_query('COMMIT');
}

function mymysql_rollback_transaction()
{
  mysql_query('ROLLBACK');

}



?>
