require_relative '../config/environment.rb'
require_relative 'scraper.rb'

class Movies
  attr_accessor :title, :rating, :runtime, :genre, :release_date, :summary, :director, :writers, :stars, :trailer_link, :rank, :year, :link

  @@all = []

  def self.save_top_20 # takes array of hashes of top 20 and creates objects
    Scraper.scrape_top_movies
    Scraper.all.each do |k, v|
      self.send(("#{k}="), v)
      @@all << self
    end
  end

  def self.select_by_rank(rank)
    index = rank -= 1
    self.all[index]
  end

  def self.create_from_list(movie_list)
    movie_list.each do |movies|
      link = movies[:link]
      info = Scraper.details(link)
      self.new(info)
    end
  end

  def self.all
    @@all
  end

end
binding.pry
