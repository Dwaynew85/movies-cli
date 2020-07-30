require_relative '../config/environment.rb'

class Scraper

  @@all = []

  def initialize #creates array of hashes that list the title, rank, year, and link of top 20 movies
    doc = Nokogiri::HTML(open("https://www.imdb.com/chart/top/?ref_=nv_mv_250")).css(".lister-list")
    imdb = doc.css(".titleColumn")
    imdb.each do |movie|
      movies = {}
      details = movie.children.map {|n| n.text.strip unless n.text.strip == ""}-[nil]
      movies[:title] = details[1]
      movies[:rank] = details[0].chomp(".")
      movies[:year] = details[2]
      movies[:link] = "https://www.imdb.com" + movie.children[1].attributes["href"].value
      @@all << movies
    end
  end

  def self.all
    @@all[0..19]
  end

  def self.details(link)
    movie_details = {}
    mov = Nokogiri::HTML(open(link))
    movie_details[:title] = mov.css(".title_wrapper h1").text.strip
    movie_details[:rating] = mov.css(".subtext").children.first.text.strip
    movie_details[:runtime] = mov.css(".subtext time").text.strip
    movie_details[:genre] = mov.css(".subtext a").map {|genre| genre.text unless genre.text =~ /\d/}-[nil]
    movie_details[:release_date] = mov.css(".subtext a").last.text.strip
    movie_details[:summary] = mov.css(".summary_text").text.strip
    movie_details[:director] = mov.css(".credit_summary_item").first.css("a").children.collect {|dir| dir.text}
    movie_details[:writers] = mov.css(".credit_summary_item")[1].css("a").children.collect {|writer| writer.text}
    stars = mov.css(".credit_summary_item").last.css("a").children.collect {|star| star.text}
    stars.pop if stars.last.include?("See full cast")
    movie_details[:stars] = stars
    unless mov.css(".slate a").first == nil
      movie_details[:trailer_link] = "https://www.imdb.com/" + mov.css(".slate a").first.attributes["href"].value
    else
      movie_details[:trailer_link] = "No Trailer Available"
    end
    movie_details
  end

end
