class MoviesController < ApplicationController

  def show
    id = params[:id] # retrieve movie ID from URI route
    @movie = Movie.find(id) # look up movie by unique ID
    # will render app/views/movies/show.<extension> by default
  end

  def index
	@all_ratings = Movie.getRatings
	col_index = {'title' => 0, 'date' => 2} # index of the columns
	session[:sort] = params[:sort] if params[:sort]
	@title_class = (session[:sort] == 'title') ? 'hilite' : ''
	@date_class = (session[:sort] == 'date') ? 'hilite' : ''
    @movies = Movie.all
	@movies = @movies.sort do |x,y|
		case session[:sort]
			when 'title'
				x.title <=> y.title
			when 'date'
				x.release_date <=> y.release_date
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
