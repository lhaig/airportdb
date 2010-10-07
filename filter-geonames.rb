#!/usr/bin/ruby

# Copyright 2007, 2008, Wiebe Cazemier
#
#
# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program.  If not, see <http://www.gnu.org/licenses/>.


# This script filters the geoname data and leaves only those records which have
# a feature class of P or A, meaning countries and cities. It also filters the
# alternate names, and leaves only those records which have an iso langauge
# code of nl. Adjust this iso language prefix to suit your needs.
#
# See the geo_names_extractor.php script for more info about geonames.

$geonames = 'geonames.csv'
$geonames_filtered = "geonames-with-feature-classes-a-and-p.csv"

$geonames_alt = 'geonames-alt.csv'
$geonames_alt_filtered = 'geonames-alt-only-useful.csv'

File.open($geonames_filtered, "w") do |output_file|
  File.open($geonames, "r") do |input_file|
    input_file.each_line do |line|
      fields = line.split("\t")
      feature_class = fields[6]
      output_file.write(line) if feature_class.downcase.match(/p|a/)
    end
  end
end

File.open($geonames_alt_filtered, "w") do |output_file|
  File.open($geonames_alt, "r") do |input_file|
    input_file.each_line do |line|
      fields = line.split("\t")
      feature_class = fields[2]
      output_file.write(line) if feature_class.downcase.match(/nl/)
    end
  end
end
