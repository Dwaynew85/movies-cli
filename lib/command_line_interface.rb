require_relative '../config/environment.rb'

class CLI
  attr_accessor :mov

  def run
    Scraper.scrape_top_movies
    Movies.create_from_list(Scraper.all)
  end

  def self.display_movies #should be using object attributes not hash
    Movies.all.each do |movie|
      puts "#{movie.rank.colorize(:yellow)} #{movie.title} #{movie.year}"
    end
  end

  def self.display_by_rank(rank)
    @mov = Movies.select_by_rank(rank)
    puts "#{"Title:".colorize(:yellow).underline} #{@mov.title}"
    puts "#{"Rated:".colorize(:yellow).underline} #{@mov.rating}"
    puts "#{"Genre:".colorize(:yellow).underline} #{@mov.genre.class == Array ? @mov.genre.uniq.join(' & ') : (@mov.gerne)}"
    puts "#{"Runtime:".colorize(:yellow).underline} #{@mov.runtime}"
    puts "#{"Release Date:".colorize(:yellow).underline} #{@mov.release_date}"
    puts "#{"Summary:".colorize(:yellow).underline} #{@mov.summary}"
    puts "#{"Directed By:".colorize(:yellow).underline} #{@mov.director.class == Array ? @mov.director.uniq.join(' & ') : (@mov.director)}"
    puts "#{"Written By:".colorize(:yellow).underline} #{@mov.writers.class == Array ? @mov.writers.uniq.join(' & ') : (@mov.writers)}"
    puts "#{"Starring:".colorize(:yellow).underline} #{@mov.stars.class == Array ? @mov.stars.uniq.join(' & ') : (@mov.stars)}"
    self.menu
  end

  def self.trailer
    puts "#{"Click the link to view trialer:".colorize(:green)}\n #{@mov.trailer_link.colorize(:blue).underline}\n"
    sleep(1)
    self.menu_2
  end

  def self.search_by_star(star)
    movies = Movies.all.select {|movie| movie.stars.include?(star) }
    opt = movies.each_with_index {|mov, index| puts "#{index + 1}. #{mov.title}" }.uniq
    puts "#{opt.length + 1}. Main Menu"
    puts "Please make a selection from the above.".colorize(:green)
    above = gets.chomp.to_i - 1
    @mov = opt[above]
    if @mov.class == Movies
      puts "#{"Title:".colorize(:yellow).underline} #{@mov.title}"
      puts "#{"Rated:".colorize(:yellow).underline} #{@mov.rating}"
      puts "#{"Genre:".colorize(:yellow).underline} #{@mov.genre.class == Array ? @mov.genre.uniq.join(' & ') : (@mov.gerne)}"
      puts "#{"Runtime:".colorize(:yellow).underline} #{@mov.runtime}"
      puts "#{"Release Date:".colorize(:yellow).underline} #{@mov.release_date}"
      puts "#{"Summary:".colorize(:yellow).underline} #{@mov.summary}"
      puts "#{"Directed By:".colorize(:yellow).underline} #{@mov.director.class == Array ? @mov.director.uniq.join(' & ') : (@mov.director)}"
      puts "#{"Written By:".colorize(:yellow).underline} #{@mov.writers.class == Array ? @mov.writers.uniq.join(' & ') : (@mov.writers)}"
      puts "#{"Starring:".colorize(:yellow).underline} #{@mov.stars.class == Array ? @mov.stars.uniq.join(' & ') : (@mov.stars)}"
      self.menu
    else
      self.menu
    end
  end

  def self.movie_select
    CLI.display_movies
    puts "Which movie's details would you like to see? Please select by ranking number:".colorize(:green)
    rank = gets.chomp.to_i
    CLI.display_by_rank(rank)
  end

  def self.menu
    puts "What would you like to do next?".colorize(:green)
    puts "#{"1.".colorize(:green)} View movie's trailer link"
    puts "#{"2.".colorize(:green)} Go back to list of top 20 movies"
    puts "#{"3.".colorize(:green)} Search for movies including your favorite star"
    puts "#{"4.".colorize(:green)} That's all, folks!(Exit)"
    menu_selection = gets.chomp
    case menu_selection
    when "1"
      self.trailer
    when "2"
      self.movie_select
    when "3"
      puts "Enter the exact spelling of the star you'd like to seach for. If they made the cut, the movies they're in will be listed.".colorize(:green)
      star = gets.chomp
      self.search_by_star(star)
    when "4"
      "Goodbye!"
      exit
    else
      puts "Please select an option between 1-3".colorize(:green)
      self.menu
    end
  end

  def self.menu_2
    puts "What would you like to do next?".colorize(:green)
    puts "#{"1.".colorize(:green)} Go back to list of top 20 movies"
    puts "#{"2.".colorize(:green)} Search for movies including your favorite star"
    puts "#{"3.".colorize(:green)} That's all, folks!(Exit)"
    menu_selection = gets.chomp
    case menu_selection
    when "1"
      self.movie_select
    when "2"
      puts "Enter the exact spelling of the star you'd like to seach for. If they made the cut, the movies they're in will be listed.".colorize(:green)
      star = gets.chomp
      self.search_by_star(star)
    when "3"
      "Goodbye!"
      exit
    else
      puts "Please select between 1-3."
      self.menu_2
    end
  end
end
