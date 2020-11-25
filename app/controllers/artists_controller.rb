class ArtistsController < ApplicationController
	def index
		@artists = current_user.artists.order(:id)
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
		@users_artist = UsersArtist.new(user_id: current_user.id)

		if artist_exists?
			redirect_to artists_url
		elsif @artist.save
			save_users_artist(@artist)
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

	def destroy
		artist = Artist.find_by(id: params[:id])
		artist.destroy
		redirect_to artists_url
	end

	def populate_albums
		artist = Artist.find_by(id: params[:artist_id])
		artist.populate_albums
		redirect_to artist_url(artist)
	end

	private
	def artist_params
		params.require(:artist).permit(:name)
	end

	def artist_exists?
		artist = Artist.find_by(artist_params)
		return false if artist.nil?
		save_users_artist(artist)
		artist.persisted?
	end

	def save_users_artist(artist)
		@users_artist.artist_id = artist.id
		@users_artist.save
	end
end