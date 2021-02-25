class MoviesController < ApplicationController

  def show
    id = params[:id] # retrieve movie ID from URI route
    @movie = Movie.find(id) # look up movie by unique ID
    # will render app/views/movies/show.<extension> by default
  end

 def index
    
    @movies = Movie.all
    @all_ratings = Movie.movie_ratings
    redirect = 0
    
    if params[:ratings]
      session[:ratings] = params[:ratings]
      #@ratings_to_show = params[:ratings].keys
    elsif session[:ratings]
      redirect = 1
      #@ratings_to_show = session[:ratings].keys
    end
    
    if params[:sort_by]
      session[:sort_by] = params[:sort_by]
      #@sort_asc = params[:sort_asc]
    elsif session[:sort_by]
      redirect = 1
      #@sort_asc = session[:sort_asc]
    end
    
    unless session[:ratings]
      session[:ratings] = Hash[@all_ratings.map{|x| [x, x]}]
    end
    
    @sort = session[:sort_by]
    @ratings_to_show = session[:ratings].keys
     
   
    #if params[:ratings]
     # @ratings_to_show = params[:ratings].keys
    #else 
     # @ratings_to_show = @all_ratings
    #end
    @movies = @movies.order(@sort)
    @movies = @movies.where(rating: @ratings_to_show)
    
    if redirect == 1
      flash.keep
      redirect_to movies_path(sort_by: session[:sort_by] , ratings: session[:ratings]) 
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

  private
  # Making "internal" methods private is not required, but is a common practice.
  # This helps make clear which methods respond to requests, and which ones do not.
  def movie_params
    params.require(:movie).permit(:title, :rating, :description, :release_date)
  end
end
