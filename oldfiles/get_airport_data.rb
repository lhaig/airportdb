require 'rubygems'
require 'nokogiri'
require 'open-uri'




url = 'http://en.wikipedia.org/wiki/List_of_airports_by_IATA_code:_A'
doc = Nokogiri::HTML(open(url))
puts doc.at_css('table.wikitable')
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


def scrape(url)
  existing_users = ScrapedUser.count

  tables = Nokogiri::HTML(Curl::Easy.perform(url).body_str).css('table')

  tables.each do |table|
    trs = table.css('tr')[1..-1]
    trs.each do |tr|  
      tds = tr.css('td:nth-child(1)')
      tds.each do |td|

        a = td.css('font a').first
        unless a.nil?
         # ScrapedUser.find_or_create_by_email(:name => td.css('font a').first.content.gsub("\n", '').squeeze(" ").strip,
                                              :email => extract_email(td.css('font a').first.attribute('href').value),
                                              :htmldump => td.css('font').first.inner_html)
        end                 
      end
    end
  end

  puts "Scraped new #{ScrapedUser.count - existing_users} users from #{url}"
end

namespace :tripswap do
  desc 'Scrape site'
  task :scrape => :environment do
    scrape("http://tripswap.net/swaps.html")
    scrape("http://www.tripswap.net/A380SYDswaps.html")
    scrape("http://www.tripswap.net/A380MELswaps.html")
    scrape("http://www.tripswap.net/cnsswaps.html")
  end
end