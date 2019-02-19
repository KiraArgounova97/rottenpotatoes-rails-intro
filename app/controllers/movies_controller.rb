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

  # Part1: Sort the column/highlight yellow =========================
  # Part2: Filter the list of the movies ============================
  # Part3: Remember the settings ====================================
  
  # 'ratings': Aggregate the values into a single hash
    @movies = Movie.all
    @all_ratings = Movie.all_ratings
    redirect = false 

    # clear up============================================================
    # (1) Sorting 
    if params[:sort_by] 
      @sorting = params[:sort_by]
    elsif session[:sort_by]
      @sorting = session[:sort_by]
      redirect = true 
    else 
      @sorting = nil 
    end

    # (2) Ratings 
    if params[:ratings]
      @ratings = params[:ratings]
      session[:ratings] = params[:ratings]
    elsif session[:ratings]
      @ratings = session[:ratings]
      redirect = true 
    else
      @ratings = []
    end
      
    if redirect 
      redirect_to movies_path(:sort_by => @sorting, :ratings => @ratings)
    end


    if @ratings
      # Only select checkboxed movies 
      @movies = Movie.where(:rating => @ratings.keys)
      @checked_ratings = @ratings.keys
    else
      @movies = Movie.all
      @checked_ratings = []
    end











    
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
