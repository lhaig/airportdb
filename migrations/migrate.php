<?php

///////////////////////////////////////////////////////////////////////
//
// Copyright 2007, 2008, Wiebe Cazemier, Rowan Rodrik van der Molen
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


// For an explantion of this script, see:
// http://www.halfgaar.net/mysql-migrations

// FIXME: test if safe mode is active. It won't run in safe mode.

require_once(dirname(__FILE__).'/../db-connection.php');
require_once(dirname(__FILE__).'/../mymysql-functions.php');
require_once(dirname(__FILE__).'/../shell-output-helpers.php');

echo_yellow("Using environment ".WEB_ENV);

echo "\n";

$migration_test_db = "migration_test";

$previous_version = intval(mymysql_select_value("SELECT MAX(migration_nr) FROM migration_history"));

chdir(dirname(__FILE__));
$handle = opendir(dirname(__FILE__));
if ( ! $handle ) trigger_error("Opening current dir failed.", E_USER_ERROR);

$migration_files = array();

while (false !== ($file = readdir($handle))) {
  if (preg_match("/([0-9]+)_([_a-zA-Z0-9]*).mysql/", $file) )
  {
    $migration_files[] = $file;
  }
}

closedir($handle);

sort(&$migration_files);

foreach($migration_files as $filename)
{
  $current_version = intval(mymysql_select_value("SELECT MAX(migration_nr) FROM migration_history"));

  $matches = array();
  preg_match("/([0-9]+)_([_a-zA-Z0-9]*).mysql$/", $filename, &$matches);
  $file_version = intval($matches[1]); // file_version is the number of the current migration file

  if ( $file_version == $previous_version )
    die_red("Duplicate versioned migration found, fool...");

  if ( $file_version > $current_version )
  {
    echo_yellow("Making dump of revsion $previous_version.");

    $dump_status = null;
    $dump_command = sprintf("mysqldump --routines --user=%s --password=%s --host=%s %s > pre_migration_%s_dump.mysql", MYMYSQL_USER, MYMYSQL_PASSWORD, MYMYSQL_HOST, MYMYSQL_DB, WEB_ENV);
    echo_green($dump_command);
    system($dump_command, &$dump_status);
    if ($dump_status != 0) die_red("Dumping pre-migration dump file failed abysmally!");

    echo "\n";
    
    // If you have DB create permissions on your production server, it should be possible to remove this condition. The generated commands should adjust accordingly. But, test it to be sure.
    if ( WEB_ENV != "production")
    {
      echo_yellow("Testing the migration on a test database. Note: this test is only done in development, because you often can't create databases on your production server because of lack of permissions. So, always test your migrations on your development DB first.");

      // drop a possibly existing test db
      $drop_test_db_query = "DROP DATABASE IF EXISTS $migration_test_db;";
      echo_green("$drop_test_db_query");
      if (! mysql_query($drop_test_db_query)) die_red("Could not delete $migration_test_db db.");

      // create a new test db, so you can be sure it's empty
      $create_test_db_query = "CREATE DATABASE $migration_test_db;";
      echo_green("$create_test_db_query");
      if (! mysql_query($create_test_db_query)) die_red("Could not create $migration_test_db db.");
      
      // load the dump of development into the test db
      $load_into_test_command = sprintf("mysql --user=%s --password=%s --host=%s $migration_test_db < pre_migration_%s_dump.mysql", MYMYSQL_USER, MYMYSQL_PASSWORD, MYMYSQL_HOST, WEB_ENV);
      echo_green("$load_into_test_command");
      $load_into_test_db_status = null;
      system($load_into_test_command, &$load_into_test_db_status);
      if ($load_into_test_db_status != 0) die_red("Loading dump into test DB failed."); 

      // Run the migration on the test db
      $test_migration_status = null;
      $migration_test_command = sprintf("mysql --user=%s --password=%s --host=%s $migration_test_db < $filename", MYMYSQL_USER, MYMYSQL_PASSWORD, MYMYSQL_HOST);
      echo_green($migration_test_command);
      system($migration_test_command, &$test_migration_status);
      if ($test_migration_status != 0 ) die_red("Migration $file_version has errors in it. Aborting.");
      
      // At this point, we know the test succeeded, so we can continue safely.
      echo_yellow("Testing of migration $file_version successful, there don't appear to be any errors. Continueing...");
    }

    echo "\n";

    // Disabled svn commit for the release of this airport crawler.
    //echo_yellow("Committing pre-migration dump of ".WEB_ENV." version $previous_version.");
    //$svn_commit_command = sprintf("svn commit -m 'Updated pre-migration dump of %s to $previous_version' pre_migration_%s_dump.mysql", WEB_ENV, WEB_ENV);
    //echo_green("$svn_commit_command");
    //$svn_commit_result = null;
    //system($svn_commit_command, &$svn_commit_result);
    //if ($svn_commit_result != 0) die_red("Commiting backup dump into svn failed.");

    echo "\n";

    // do stuff here that executes the migration.
    echo_yellow("Migrating from version $previous_version to $file_version.");
    $migration_status = null;
    $migration_command = sprintf("mysql --user=%s --password=%s --host=%s %s < $filename", MYMYSQL_USER, MYMYSQL_PASSWORD, MYMYSQL_HOST, MYMYSQL_DB);
    echo_green($migration_command);
    system($migration_command, &$migration_status);

    // If loading the migration failed.
    if ($migration_status != 0)
    {
      echo "\n";

      die_red("Migration failed! You now have a possible inconsistent database, because it did pass the initial test, but failed when the migration was actually run. You need to find out what statements of the migration did work, and bring it back to the state of the previous migration. For the record, migration $file_version is the one that failed. \n");

    }

    echo "\n";

    // Insert the version number of the migration into the migration_history table.
    echo_yellow("Inserting version $file_version into migration_history table");
    mymysql_insert("migration_history", array("migration_nr" => $file_version));

    echo "\n\n\n";
  }

  $previous_version = $file_version;
}

?>
