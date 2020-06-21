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
    self.menu
  end

  def self.trailer
    puts "Click the link to view trialer:\n #{@mov.trailer_link}\n"
    sleep(1)
    self.menu_2
  end

  def self.search_by_star(star)
    movies = Movies.all.select {|movie| movie.stars.include?(star) }
    opt = movies.each_with_index {|mov, index| puts "#{index + 1}. #{mov.title}" }.uniq
    puts "#{opt.length + 1}. Main Menu"
    puts "Please make a selection from the above."
    above = gets.chomp.to_i - 1
    @mov = opt[above]
    if @mov.class == Movies
      puts "Title: #{@mov.title}"
      puts "Rated: #{@mov.rating}"
      puts "Genre: #{@mov.genre.class == Array ? @mov.genre.uniq.join(' & ') : (@mov.gerne)}"
      puts "Runtime: #{@mov.runtime}"
      puts "Released: #{@mov.release_date}"
      puts "Summary: #{@mov.summary}"
      puts "Directed By: #{@mov.director.class == Array ? @mov.director.uniq.join(' & ') : (@mov.director)}"
      puts "Written By: #{@mov.writers.class == Array ? @mov.writers.uniq.join(' & ') : (@mov.writers)}"
      puts "Starring: #{@mov.stars.class == Array ? @mov.stars.uniq.join(' & ') : (@mov.stars)}"
      self.menu
    else
      self.menu
    end
  end

  def self.movie_select
    CLI.display_movies
    puts "Which movie's details would you like to see? Please select by ranking number:"
    rank = gets.chomp.to_i
    CLI.display_by_rank(rank)
  end

  def self.menu
    puts "What would you like to do next?"
    puts "1. View movie's trailer link"
    puts "2. Go back to list of top 20 movies"
    puts "3. Search for movies including your favorite star"
    puts "4. That's all, folks!(Exit)"
    menu_selection = gets.chomp
    case menu_selection
    when "1"
      self.trailer
    when "2"
      self.movie_select
    when "3"
      puts "Enter the exact spelling of the star you'd like to seach for. If they made the cut, the movies they're in will be listed."
      star = gets.chomp
      self.search_by_star(star)
    when "4"
      exit
    else
      puts "Please select an option between 1-3"
      self.menu
    end
  end

  def self.menu_2
    puts "What would you like to do next?"
    puts "1. Go back to list of top 20 movies"
    puts "2. Search for movies including your favorite star"
    puts "3. That's all, folks!(Exit)"
    menu_selection = gets.chomp
    case menu_selection
    when "1"
      self.movie_select
    when "2"
      puts "Enter the exact spelling of the star you'd like to seach for. If they made the cut, the movies they're in will be listed."
      star = gets.chomp
      self.search_by_star(star)
    when "3"
      exit
    when "4"
      puts "You sure you wanna go for broke? Select y or n"
      broke = gets.chomp
      if broke == "y" || broke =="Y"
        puts "Here's the top 250!!!!"
         self.display_wowzers
       else
         exit
       end
    else
      puts "Please select between 1-4...I meant 3! 1-3. Don't select 4."
      self.menu_2
    end
  end

  def self.display_wowzers
    Scraper.wowzers.each do |movie|
      puts "#{movie[:rank]} #{movie[:title]} #{movie[:year]}"
    end
    puts "Which movie's details would you like to see? Please select by ranking number:"
    rank = gets.chomp.to_i
    CLI.display_by_rank(rank)
  end

end
