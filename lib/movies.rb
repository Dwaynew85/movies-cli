require_relative '../config/environment.rb'

class Movies
  attr_accessor :title, :rating, :runtime, :genre, :release_date, :summary, :director, :writers, :stars, :trailer_link, :rank, :year, :link

  @@all = []

  def initialize(details_hash)
    details_hash.each {|k, v| self.send(("#{k}="), v)}
    @@all << self
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
