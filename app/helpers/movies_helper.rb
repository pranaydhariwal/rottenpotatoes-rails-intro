module MoviesHelper
  # Checks if a number is odd:
  def oddness(count)
    count.odd? ?  "odd" :  "even"
  end
  
  def sort_movie_title()
     link_to "Movie Title",{column: "movie_names"}, :id => "title_header"
  end
  
  def sort_release_date()
    link_to "Release Date",{column: "rel_date"}, :id => "release_date_header"
  end
end
