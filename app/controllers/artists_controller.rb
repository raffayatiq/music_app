class ArtistsController < ApplicationController
	def index
		@artists = Artist.all
		render :index
	end

	def show
		@artist = Artist.find_by(id: params[:id])

		if @artist.nil?
			redirect_to artists_url 
		else
			render :show
		end
	end

	def new
		@artist = Artist.new
		render :new
	end

	def create
		@artist = Artist.new(artist_params)

		if @artist.save
			redirect_to artists_url
		else
			flash.now[:errors] = @artist.errors.full_messages
			render :new
		end
	end

	def edit
		@artist = Artist.find_by(id: params[:id])
		render :edit
	end

	def update
		@artist = Artist.find_by(id: params[:id])

		if @artist.update_attributes(artist_params)
			redirect_to artist_url(@artist)
		else
			flash.now[:errors] = @artist.errors.full_messages
			render :edit
		end
	end

	private
	def artist_params
		params.require(:artist).permit(:name)
	end
end