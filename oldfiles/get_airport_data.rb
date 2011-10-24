require 'rubygems'
require 'nokogiri'
require 'open-uri'

alphabet = ('A'..'Z').to_a

domain = 'http://en.wikipedia.org'

airports = []

alphabet.each do |letter|
  sleep 1
  url = "#{domain}/wiki/List_of_airports_by_IATA_code:_#{letter}"
  doc = Nokogiri::HTML(open(url))
  rows = doc.css('table.wikitable tr')

  rows = rows[2..-1]

  rows.each do |row|
    next unless row.attribute('class').nil?
    # code
    code = row.css('td')[0].text
  
    # name
    name = row.css('td')[2].text
  
    href = row.css('td')[2].css('a').attribute('href').value
  
    airports << {:code => code, :name => name, :href => href}
  end

  airports.each do |airport|
    sleep 1
    puts "curling #{domain}#{airport[:href]}"
    doc = Nokogiri::HTML(open("#{domain}#{airport[:href]}"))
    airport[:geolocation] = doc.css('#coordinates .geo-dec').text
    puts airport[:geolocation]
  end

end

puts airports

# .geo-dec



#doc.css("p").each do |alphabet|
#  puts alphabet.at_css(".selflink")
#end

#require 'curb'


#td:nth-child(3) , #sortable_table_id_0 td:nth-child(1)
#td:nth-child(3) , td:nth-child(1)



#def extract_iatacode(string)
#  m = string.match(/mailto:(.+)/xi)
#  m[1] unless m.nil?
#end


# def scrape(url)
#   existing_users = ScrapedUser.count
# 
#   tables = Nokogiri::HTML(Curl::Easy.perform(url).body_str).css('table')
# 
#   tables.each do |table|
#     trs = table.css('tr')[1..-1]
#     trs.each do |tr|  
#       tds = tr.css('td:nth-child(1)')
#       tds.each do |td|
# 
#         a = td.css('font a').first
#         unless a.nil?
#          # ScrapedUser.find_or_create_by_email(:name => td.css('font a').first.content.gsub("\n", '').squeeze(" ").strip,
#                                               :email => extract_email(td.css('font a').first.attribute('href').value),
#                                               :htmldump => td.css('font').first.inner_html)
#         end                 
#       end
#     end
#   end
# 
#   puts "Scraped new #{ScrapedUser.count - existing_users} users from #{url}"
# end
# 
# namespace :tripswap do
#   desc 'Scrape site'
#   task :scrape => :environment do
#     scrape("http://tripswap.net/swaps.html")
#     scrape("http://www.tripswap.net/A380SYDswaps.html")
#     scrape("http://www.tripswap.net/A380MELswaps.html")
#     scrape("http://www.tripswap.net/cnsswaps.html")
#   end
# end