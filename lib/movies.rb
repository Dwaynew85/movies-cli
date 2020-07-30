require_relative '../config/environment.rb'
require_relative 'scraper.rb'

class Movies
  attr_accessor :title, :rating, :runtime, :genre, :release_date, :summary, :director, :writers, :stars, :trailer_link, :rank, :year, :link

  @@all = []
  @@detail = []

  def save_from_scraper(hash)
    hash.each {|k, v| self.send(("#{k}="), v)}
    @@all << self
  end

  def self.all
    @@all
  end

  def save_details(hash)
    hash.each {|k, v| self.send(("#{k}="), v)}
    @@detail << self
  end

  def self.details
    @@detail
  end


  def self.select_by_rank(rank) #shouldn't have seperate details array. adds to movie object
    index = rank -= 1
    self.details[index]
  end

  def self.create_from_list(movie_list)
    movie_list.each do |movies|
      link = movies[:link]
      info = Scraper.details(link)
      movie= self.new
      movie.save_details(info)
      @@all << movie
    end
  end

end
