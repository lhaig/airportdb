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


BEGIN;

DELETE FROM airport_codes;

LOAD DATA LOCAL INFILE 'www.world-airport-codes.com.csv'
  INTO TABLE airport_codes
  FIELDS TERMINATED BY ':'
  LINES TERMINATED BY '\n' STARTING BY ''
  (airport_code,airport_name,city_name,country_name,country_code,@longitude,@latitude,world_area_code)
  SET latitude = geo_dms_to_decimal(@latitude),
      longitude = geo_dms_to_decimal(@longitude)
  ; 

COMMIT;
