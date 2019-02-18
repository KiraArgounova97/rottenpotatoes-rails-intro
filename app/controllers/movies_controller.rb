class MoviesController < ApplicationController

  def movie_params
    params.require(:movie).permit(:title, :rating, :description, :release_date)
  end

  def show
    id = params[:id] # retrieve movie ID from URI route
    @movie = Movie.find(id) # look up movie by unique ID
    # will render app/views/movies/show.<extension> by default
  end

  
  # ===================================================================
  
  def index   
    @movies = Movie.all 
    
    # Part1: Sort the column/highlight yellow =========================
   if params[:sort_by] == 'title'
    @title_header = 'hilite'
    @movies = Movie.order(title: :asc)
   elsif params[:sort_by] == 'release_date'
    @release_date_header = 'hilite'
    @movies = Movie.order(release_date: :asc)
   end
   
    # Part2: Filter the list of the movies ===========================
    @all_ratings = Movie.all_ratings
    # Aggregate the values into a single hash called 'ratings'
    if params[:rating]
      @ratings = params[:rating]
    else
      @ratings = nil
    end
    
    @ratings.keys
  end


# ====================================================================

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
