# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

region = Region.create([{code: 'ZA-GT' }, {local_code: 'GT' }, {name: 'Gauteng' }, {continent: 'AF' }, {iso_country: 'ZA'}, {wikipedia_link: 'http://en.wikipedia.org/wiki/Gauteng'}, {keywords: ''}])
# country = Country.create([{code: 'ZA'}, {name: 'South Africa'}, {continent: 'AF'}, {wikipedia_link: 'http://en.wikipedia.org/wiki/South_Africa'}, {keywords: ''}])
# airport = Airport.create([{ident: 'FAJS'}, {type: 'large_airport'}, {name: 'OR Tambo International Airport'}, {latitude_deg: '-26.1392002106'}, {longitude_deg: '28.2460002899'}, {elevation_ft: '5558'}, {continent: 'AF'}, {iso_country: 'ZA'}, {iso_region: 'ZA-GT'}, {municipality: 'Johannesburg'}, {scheduled_service: 'yes'}, {gps_code: 'FAJS'}, {iata_code: 'JNB'}, {local_code: ''}, {home_link: 'http://www.acsa.co.za/home.asp?pid=228'}, {wikipedia_link: 'http://en.wikipedia.org/wiki/OR_Tambo_International_Airport'}, {keywords: 'Johannesburg International Airport, Jan Smuts International Airport'}])