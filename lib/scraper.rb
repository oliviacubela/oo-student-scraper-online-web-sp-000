require 'nokogiri'
require 'open-uri'

class Scraper

  def self.scrape_index_page(index_url)
    doc = Nokogiri::HTML(open(index_url))
    index_page = doc.css(".student-card a")
    index_page.collect do |element|
      {:name => element.css(".student-name").text ,
        :location => element.css(".student-location").text,
        :profile_url => element.attr('href')
      }
    end
  end

  def self.scrape_profile_page(profile_url)
    students_hash = {}

    profile_page = Nokogiri::HTML(open(profile_url))
    links = profile_page.css(".social-icon-container").children.css("a").map {|element| element.attribute('href').value}
    links.each do |link|
      if link.include?("twitter")
        students_hash[:twitter] = link
      elsif link.include?("linkedin")
        students_hash[:linkedin] = link
      elsif link.include?("github")
        students_hash[:github] = link
      else
        students_hash[:blog] = link
      end
    end

    students_hash[:profile_quote] = profile_page.css(".profile-quote").text if profile_page.css(".profile-quote").text
    students_hash[:bio] = profile_page.css("div.bio-content.content-holder div.description-holder p").text if profile_page.css("div.bio-content.content-holder div.description-holder p")

    students_hash
  end
end
