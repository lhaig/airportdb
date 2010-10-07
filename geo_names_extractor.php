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

// This scripts sets a city_name_geo_name_id and country_name_geo_name_id for 
// each airport, if it can find one.
// It also sets the dutch country and city names for each airport in the 
// second while loop. You can change the iso language code to the one you're 
// interested in. Or, you can comment out that second while loop.
//
// Should you wonder why it doesn't load the geoname data into the DB and do a 
// join; that is because the geoname data is HUGE...

require_once(dirname(__FILE__).'/db-connection.php');
require_once(dirname(__FILE__).'/mymysql-functions.php');

$geo_names_file_handle = fopen("geonames-with-feature-classes-a-and-p.csv", "r");

$geo_name_counter = 0;
$geo_name_alt_counter = 0;

mymysql_begin_transaction();

// First reset everything this script is going to set
mysql_query("delete from cities");
mysql_query("UPDATE airport_codes SET city_name_nl = null, country_name_nl = null, city_name_geo_name_id = null, country_name_geo_name_id = null");

echo "Reading geonames and setting *_geo_name_ids for cities and countries.  
This can take a while, as it has to process millions of cities and 
countries (about 2.5 million with current geonames data).\n";

while($geo_names_line = fgets($geo_names_file_handle))
{
  list($id, $name, $ascii_name, $alternate_names, $latitude , $longitude , $feature_class, $feature_code, 
    $country_code, , , , , , $population , , , , ) = split("\t", $geo_names_line);

  $id = (int) $id;

  // The alternate names can contain the actual name you're looking for. The 
  // name itself can be unusual like "Kingdom of The Netherlands".
  $alternate_names_array = split(",", $alternate_names);
  $alternate_names_where_clause = "";

  foreach($alternate_names_array as $alternate_name)
  {
    if ( $alternate_name )
    {
      $alternate_name = mysql_real_escape_string($alternate_name);
      $alternate_names_where_clause .= " OR country_or_city_name_placeholder LIKE '$alternate_name'";
    }
  }

  if ( 'P' == $feature_class ) // Feature class P should be cities, so set city_name_geo_name_id's
  {
    // Checking if a city has more than a certain number of inhabitants filters 
    // out unwanted duplicate entries. I hope it holds up. Countries almost never 
    // have a population count, so this check only works for cities.
    if ( $population > 1000 )
    {
      $alternate_names_where_clause = str_replace("country_or_city_name_placeholder", "city_name", 
        $alternate_names_where_clause);
          
      // set the city_name_geo_name_id for the city in question.
      // The strange construct with the substrings, it to match only everything 
      // before the comma, and then try the string before and after the slash 
      // in city_names like "Raleigh/Durham, NC"
      //
      // TODO: Also use the substring construction for comparing city_name to 
      // name_ascii. It's not too relevant, because the few airports which have 
      // a / or , it it's city_name, don't seem to have special characters.
      //
      //echo "Processing: city: $name in $country_code, id: $id\n"; // Generates too much output, which makes it slow.
      
      $nr_of_updated_rows = mymysql_update("airport_codes", 
        array("(substring_index(substring_index(city_name,',',1),'/',1) LIKE :name 
        OR substring_index(substring_index(city_name,',',1),'/',-1) LIKE :name
        OR city_name LIKE :name_ascii $alternate_names_where_clause) 
        AND country_code = :country_code", 
        array('name' => $name, "name_ascii" => $ascii_name, 'country_code' => $country_code)), 
        array('city_name_geo_name_id' => $id));

      // At first you may think that the amount of cities should be the same as 
      // the amount of airport_codes records with city_name_geo_name_id IS 
      // NULL, but this is not the case. When rows in the airport_codes table 
      // are updated multiple times because of multiple entries in the 
      // geo_names csv file, a new city is inserted here. This _should_ pose no problems.
      if ( $nr_of_updated_rows > 0 )
        mymysql_insert("cities", array('geo_name_id' => $id, 'latitude' => $latitude, 'longitude' => $longitude));
    }
  }
  elseif ( 'A' == $feature_class ) // Feature class A should be countries, so set country_name_geo_name_id
  {
    $alternate_names_where_clause = str_replace("country_or_city_name_placeholder", "country_name", 
      $alternate_names_where_clause);
    
    // set the country_name_geo_name_id for the country in question.
    //echo "Processing: country: $name, id: $id\n"; // Generates too much output, which makes it slow.
    mymysql_update("airport_codes", 
      array("(substring_index(country_name,',',1) LIKE :name 
      OR country_name LIKE :name_ascii $alternate_names_where_clause) 
      AND country_code = :country_code", 
      array('name' => $name, "name_ascii" => $ascii_name, 'country_code' => $country_code)), 
      array('country_name_geo_name_id' => $id));
  }

  $geo_name_counter++;
  if ($geo_name_counter % 500 == 0 ) echo "Processed amount of cities or countries: $geo_name_counter.\n";
}

echo "\n";



$alternate_names_file_handle = fopen("geonames-alt-only-useful.csv", "r");

echo "Running update queries to set dutch city and country names, using the previously set geo_name_ids to find them.\n";

while($alternate_names_line = fgets($alternate_names_file_handle))
{
  list($id, $geo_name_id, $iso_language, $alternate_name, , ) = explode("\t", $alternate_names_line);

  if ( $iso_language == 'nl' )
  {
    echo "  - Updating country names...\n";
    mymysql_update("airport_codes", "country_name_geo_name_id = $geo_name_id", array('country_name_nl' => $alternate_name));

    echo "  - Updating city names...\n";
    mymysql_update("airport_codes", "city_name_geo_name_id = $geo_name_id", array('city_name_nl' => $alternate_name));
  }
}

//mymysql_rollback_transaction(); // debug stuff
mymysql_commit_transaction();

?>
