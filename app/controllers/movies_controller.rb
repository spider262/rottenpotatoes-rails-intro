class MoviesController < ApplicationController

  def movie_params
    params.require(:movie).permit(:title, :rating, :description, :release_date, :sort_by)
  end

  def show
    id = params[:id] # retrieve movie ID from URI route
    @movie = Movie.find(id) # look up movie by unique ID
    # will render app/views/movies/show.<extension> by default
  end
  
  def index
    #sort = params[:sort_by] || session[:sort_by]
    @movies = Movie.order(params[:sort_by])
    @all_ratings = Movie.all_ratings
    @selected_ratings = params[:ratings] || session[:ratings] || {}

    if params[:sort_by] != session[:sort_by] or params[:ratings] != session[:ratings]
      session[:sort_by] = sort
      session[:ratings] = @selected_ratings
      redirect_to :sort_by => sort, :ratings => @selected_ratings and return
    end

    @movies = @movies.where(:rating => params[:ratings].keys) if params[:ratings].present?
=begin
    #@all_ratings = Movie.all.select('rating').distinct
    @all_ratings = Movie.all_ratings
    @movies = Movie.order(params[:sort_by])   #sort
    @selected_ratings = params[:ratings]
    @movies = @movies.where(:rating => selected_ratings.keys) if params[:ratings].present?
=end




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
