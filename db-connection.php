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


// Production database server is not relevant for the airport or geoname stuff. 
// Define your DB as development DB.
if ( getenv('WEB_ENV') == 'production' ) {
  define('MYMYSQL_HOST', 'hostname');
  define('MYMYSQL_USER', 'username');
  define('MYMYSQL_PASSWORD', 'password');
  define('WEB_ENV', 'production');
}
else {
  define('MYMYSQL_HOST', 'hostname');
  define('MYMYSQL_USER', 'username');
  define('MYMYSQL_PASSWORD', 'password');
  define('WEB_ENV', 'development');
}

define('MYMYSQL_DB', 'databasename');

mysql_connect(MYMYSQL_HOST, MYMYSQL_USER, MYMYSQL_PASSWORD) or die('Could not connect: ' . mysql_error());
mysql_select_db(MYMYSQL_DB);

# It depends on your PHP version which of these two you need to set the 
# character encoding.
#mysql_set_charset("utf8"); # Use with PHP >= 5.2.3
mysql_query("SET NAMES 'utf8'"); # Use with older PHP's

?>
