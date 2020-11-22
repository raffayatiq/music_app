class AlbumsController < ApplicationController
	def show
		@album = Album.find_by(id: params[:id])
		render :show
	end

	#nested
	def new
		@album = Album.new
		@album.band_id = params[:band_id]
		render :new
	end

	def create
		@album = Album.new(album_params)

		if @album.save
			redirect_to album_url(@album)
		else
			flash.now[:errors] = @album.errors.full_messages
			render :new
		end
	end

	def edit
		@album = Album.find_by(id: params[:id])
		render :edit
	end

	def update
		@album = Album.find_by(id: params[:id])

		if @album.update_attributes(album_params)
			redirect_to album_url(@album)
		else
			flash.now[:errors] = @album.errors.full_messages
			render :edit
		end
	end

	def destroy
		@album = Album.find_by(id: params[:id])
		album_band = @album.band
		@album.destroy
		redirect_to band_url(album_band)
	end

	private
	def album_params
		params[:album][:version] = params[:album][:version] == "Studio" ? true : false
		params.require(:album).permit(:title, :year, :band_id, :version)
	end
end