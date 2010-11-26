-- Copyright 2007, 2008, Wiebe Cazemier, Rowan Rodrik van der Molen
-- 
-- 
-- This program is free software: you can redistribute it and/or modify
-- it under the terms of the GNU General Public License as published by
-- the Free Software Foundation, either version 3 of the License, or
-- (at your option) any later version.
-- 
-- This program is distributed in the hope that it will be useful,
-- but WITHOUT ANY WARRANTY; without even the implied warranty of
-- MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
-- GNU General Public License for more details.
-- 
-- You should have received a copy of the GNU General Public License
-- along with this program.  If not, see <http://www.gnu.org/licenses/>.


SELECT airport_code, airport_name, city_name, country_name, country_code, latitude, longitude, world_area_code, country_name_nl, city_name_nl, city_name_geo_name_id, country_name_geo_name_id 
FROM airport_codes 
INTO OUTFILE './airport_codes_with_geo_name_ids_and_nl_names.csv' 
FIELDS TERMINATED BY ',' 
OPTIONALLY ENCLOSED BY '"' 
LINES TERMINATED BY '\n';

SELECT geo_name_id, latitude, longitude
FROM cities 
INTO OUTFILE './city_geo_name_ids_and_coordinates.csv' 
FIELDS TERMINATED BY ',' 
OPTIONALLY ENCLOSED BY '"' 
LINES TERMINATED BY '\n';
