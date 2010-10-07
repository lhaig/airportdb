#!/usr/bin/ruby

#######################################################################
# Copyright 2007, 2008, Rowan Rodrik van der Molen, Wiebe Cazemier.
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
#######################################################################


# Because www.world-airport-codes.com does not offer a convenient download, you
# can use this script to download the database they make available through HTML
# pages. It outputs to standard out, so its output can be captured with shell
# redirects.
require 'rubygems'
require 'scrapi'
require 'htmlentities'
Tidy.path = “/usr/lib/libtidy.dylib”


$BASE_URL = "http://www.world-airport-codes.com"
$USER_AGENT = 'Mozilla/5.0 (compatible; Googlebot/2.1; +http://www.google.com/bot.html)'

$entity_coder = HTMLEntities.new

class WorldAirportCodesScraper < Scraper::Base

  class CountryLetter < Scraper::Base
    array :airport_urls, :airports

    process "tr.one > td:nth-of-type(2) > a", :airport_urls => "@href"
    process "tr.two > td:nth-of-type(2) > a", :airport_urls => "@href"

    result :airports

    def collect()
      if airport_urls # can be nil when there are no airports.
        airport_urls.each do |url|
          url = $BASE_URL + url
          @airports ||= []
          @airports << WorldAirportCodesScraper::Airport.scrape(URI.parse(url), :user_agent => $USER_AGENT)
          sleep(0.5) # Could be enabled to prevent the remote server from thinking it's being attacked.
        end
      end
    end
  end

  class Airport < Scraper::Base
    process "div.airportdetails div.column1 span.detail:nth-of-type(1)", :airport_code => :text
    process "div.airportdetails div.column1 span.detail:nth-of-type(2)", :airport_name => :text
    process "div.airportdetails div.column1 span.detail:nth-of-type(5)", :city_name => :text
    process "div.airportdetails div.column1 span.detail:nth-of-type(6)", :country_name => :text
    process "div.airportdetails div.column1 span.detail:nth-of-type(7)", :country_code => :text
    process "div.airportdetails div.column2 span.detail:nth-of-type(1)", :longitude => :text
    process "div.airportdetails div.column2 span.detail:nth-of-type(2)", :latitude => :text
    process "div.airportdetails div.column2 span.detail:nth-of-type(3)", :world_area_code => :text

    def collect()
      valid_coordinates = true
      # Some coordinates do not contain north/south or east/west info. These are useless.
      valid_coordinates = false unless latitude.match(/N|S/) and longitude.match(/E|W/)

      self.airport_code = airport_code.sub(/^:\s*([^(<]*).*$/, '\1').strip
      self.airport_name = airport_name.sub(/^:\s*([^(<]*)\(.*$/, '\1').strip
      self.city_name = city_name.sub(/^:\s*([^(<]*)\(.*$/, '\1').strip
      self.country_name = country_name.sub(/^:\s*([^(<]*)\(.*$/, '\1').strip
      self.country_code = country_code.sub(/^:\s*([^(<]*)\(.*$/, '\1').strip
      self.world_area_code = world_area_code.sub(/^:\s*([^(<]*)\(.*$/, '\1').strip
      self.longitude = longitude.sub(/: (\d+)&[^;]+; (\d+)&[^;]+; (\d+)&[^;]+; (W|E).*/, '\1 \2 \3 \4')
      self.latitude = latitude.sub(/: (\d+)&[^;]+; (\d+)&[^;]+; (\d+)&[^;]+; (N|S).*/, '\1 \2 \3 \4')

      %w{airport_code airport_name city_name country_name country_code world_area_code longitude latitude}.each do |attr|
        send("#{attr}=", '') if send(attr) =~ /Unknown/
      end

      line = "#{airport_code}:#{airport_name}:#{city_name}:#{country_name}:#{country_code}:#{longitude}:#{latitude}:#{world_area_code}"

      # Decode the HTML entities from the result into UTF8
      line = $entity_coder.decode(line)

      correct_nr_of_csv_fields = true
      correct_nr_of_csv_fields = false if line.count(':') != 7

      if valid_coordinates and correct_nr_of_csv_fields
        puts line 
      else
        warn "discarding: #{line}"
        warn "check flags: valid coordinates: #{valid_coordinates}, correct nr of csv fields: #{correct_nr_of_csv_fields}"
        warn ""
      end
    end

    result :airport_code, :airport_name, :city_name, :country_name, :country_code, :longitude, :latitude, :world_area_code
  end
end

# Loop 'a' through 'z' (you don't say...)
('a'..'z').each do |letter|
  warn "country letter: #{letter}"
  country_letter_url = URI.parse("#{$BASE_URL}/alphabetical/country-name/#{letter}.html")
  WorldAirportCodesScraper::CountryLetter.scrape(country_letter_url, :user_agent => $USER_AGENT)
end

