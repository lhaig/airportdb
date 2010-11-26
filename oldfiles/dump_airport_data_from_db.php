<?php

///////////////////////////////////////////////////////////////////////
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


// This scripts dumps the airport_codes and cities tables to csv.

require_once(dirname(__FILE__).'/db-connection.php');
require_once(dirname(__FILE__).'/shell-output-helpers.php');

$reload_command = sprintf("mysql --user=%s --password=%s --host=%s %s < dump_airport_data_from_db.sql", MYMYSQL_USER, MYMYSQL_PASSWORD, MYMYSQL_HOST, MYMYSQL_DB);
$reload_command_status = null;
echo_green("$reload_command");
echo "Note: files will be written in your mysql home dir. This is likely to be something like /var/lib/mysql/.\n";
system($reload_command, &$reload_command_status);
if ($reload_command_status != 0) die_red("Executing sql file failed");

?>
