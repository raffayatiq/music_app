class TracksController < ApplicationController
	def show
		@track = Track.find_by(id: params[:id])
		render :show
	end

	#nested
	def new
		@track = Track.new
		@track.album_id = params[:album_id]
		render :new
	end

	def create
		@track = Track.new(track_params)

		if @track.save
			redirect_to album_url(@track.album)
		else
			flash.now[:errors] = @track.errors.full_messages
			render :new
		end
	end

	def edit
		@track = Track.find_by(id: params[:id])
		render :edit
	end

	def update
		@track = Track.find_by(id: params[:id])

		if @track.update_attributes(track_params)
			redirect_to track_url(@track)
		else
			flash.now[:errors] = @track.errors.full_messages
			render :edit
		end
	end

	def destroy
		@track = Track.find_by(id: params[:id])
		track_album = @track.album
		@track.destroy
		redirect_to album_url(track_album)
	end

	def find_lyrics
		@track = Track.find_by(id: params[:track_id])
		@track.lyrics = @track.find_lyrics

		@track.save
		flash[:errors] = ["Could not find lyrics"] if @track.lyrics.empty?
		redirect_to track_url(@track)
		
	end

	private
	def track_params
		params.require(:track).permit(:title, :lyrics, :album_id)
	end
end