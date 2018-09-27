class MoviesController < ApplicationController

  def movie_params
    params.require(:movie).permit(:title, :rating, :description, :release_date)
  end

  def show
    id = params[:id] # retrieve movie ID from URI route
    @movie = Movie.find(id) # look up movie by unique ID
    # will render app/views/movies/show.<extension> by default
  end
  
  def params_support
    if session[:column] == nil or (params[:column]!=session[:column] and params[:column]!=nil)
      if params[:column] == nil and session[:column] == nil
        session[:column] = ""
      else
        session[:column] = params[:column]
      end
    end
  end
  
  def session_support
    if session[:ratings] == nil or params[:commit]!=nil
      if params[:ratings] == nil
        session[:ratings] = []
      else 
        session[:ratings] = params[:ratings]
      end
    end
  end

 def index
  params_support
  session_support
  @all_ratings = Movie.uniq.pluck(:rating)
  @boxes = session[:ratings]
  if session[:column] == "rel_date"
    if session[:ratings].blank?
      @movies = Movie.order(:release_date).all
    else
      @movies = Movie.order(:release_date).select {|i| @boxes.include?(i.rating)?true:false}
    end
    @css_valid = 0
  elsif session[:column] == "movie_names"
    if session[:ratings].blank?
      @movies = Movie.order(:title).all
    else
      @movies = Movie.order(:title).select {|i| @boxes.include?(i.rating)?true:false}
    end
    @css_valid = 1
  else 
    if not session[:ratings].blank?
      @movies = Movie.all.select {|i| @boxes.include?(i.rating)?true:false}
    else 
      @movies = Movie.all
    end
  end
 end

  def new
    # default: render 'new' template
  end

  def create
    @movie = Movie.create!(movie_params)
    flash[:notice] = "#{@movie.title} was successfully created."
    redirect_to movies_path
  end

  def edit
    @movie = Movie.find params[:id]
  end

  def update
    @movie = Movie.find params[:id]
    @movie.update_attributes!(movie_params)
    flash[:notice] = "#{@movie.title} was successfully updated."
    redirect_to movie_path(@movie)
  end

  def destroy
    @movie = Movie.find(params[:id])
    @movie.destroy
    flash[:notice] = "Movie '#{@movie.title}' deleted."
    redirect_to movies_path
  end

end
