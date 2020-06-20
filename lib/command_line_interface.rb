require_relative '../config/environment.rb'

class CLI
  attr_accessor :mov

  def run
    Scraper.new
    Movies.create_from_list(Scraper.all)
  end

  def self.display_movies
    Scraper.all.each do |movie|
      puts "#{movie[:rank]} #{movie[:title]} #{movie[:year]}"
    end
  end

  def self.display_wowzers
    Scraper.wowzers.each do |movie|
      puts "#{movie[:rank]} #{movie[:title]} #{movie[:year]}"
    end
  end

  def self.display_by_rank(rank)
    @mov = Movies.select_by_rank(rank)
    puts "Title: #{@mov.title}"
    puts "Rated: #{@mov.rating}"
    puts "Genre: #{@mov.genre.class == Array ? @mov.genre.uniq.join(' & ') : (@mov.gerne)}"
    puts "Runtime: #{@mov.runtime}"
    puts "Released: #{@mov.release_date}"
    puts "Summary: #{@mov.summary}"
    puts "Directed By: #{@mov.director.class == Array ? @mov.director.uniq.join(' & ') : (@mov.director)}"
    puts "Written By: #{@mov.writers.class == Array ? @mov.writers.uniq.join(' & ') : (@mov.writers)}"
    puts "Starring: #{@mov.stars.class == Array ? @mov.stars.uniq.join(' & ') : (@mov.stars)}"
  end

  def self.trailer
    @mov.trailer_link
  end

  def self.search
    search = gets.chomp
    case search
    when "1"
      self.display_movies
      puts "Which movie's info would you like to see? Select between 1-20"
      rank = gets.chomp.to_i
      self.display_by_rank(rank)
    else
      puts "Please select either '1' to search by ranking, or '2' to search by star's name."
      self.search
    end
  end

end
