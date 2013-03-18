class MoviesController < ApplicationController

  def show
    id = params[:id] # retrieve movie ID from URI route
    @movie = Movie.find(id) # look up movie by unique ID
    # will render app/views/movies/show.<extension> by default
  end

  def index
	@all_ratings = Movie.getRatings
	@ratings_values = Hash.new
	@movies = Array.new
	if params[:sort]
		session[:sort] = params[:sort]
	end
	unless session[:ratings]
		session[:ratings] = Hash.new
	end
	if params[:commit] # If they used the refresh button
		if params[:ratings]
			@all_ratings.each do |x| #go through all ratings and update values
				if params[:ratings][x] # if the rating is checked
					session[:ratings][x] = true
				else #It's not there
					session[:ratings][x] = false
				end
			end
		end
	end

	@title_class = (session[:sort] == 'title') ? 'hilite' : ''
	@date_class = (session[:sort] == 'date') ? 'hilite' : ''
	@all_ratings.each do |x|
		if session[:ratings][x]
			@ratings_values[x] =  true
			@movies = @movies + Movie.find_all_by_rating(x)
		elsif session[:ratings][x] == false
			@ratings_values[x] = false
		else
			session[:ratings][x] = true
			@ratings_values[x] =  true
			@movies = @movies + Movie.find_all_by_rating(x)
		end
	end
	if session[:sort]
		@movies = @movies.sort do |x,y|
			case session[:sort]
				when 'title'
					x.title <=> y.title
				when 'date'
					x.release_date <=> y.release_date
			end
		end
	end

  end

  def new
    # default: render 'new' template
  end

  def create
    @movie = Movie.create!(params[:movie])
    flash[:notice] = "#{@movie.title} was successfully created."
    redirect_to movies_path
  end

  def edit
    @movie = Movie.find params[:id]
  end

  def update
    @movie = Movie.find params[:id]
    @movie.update_attributes!(params[:movie])
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
