class Album < ApplicationRecord
	validates :title, :year, presence: true
	validates :artist_id, uniqueness: { scope: :title}
	validates :year, numericality: { greater_than: 1900, less_than: 9000 }

	belongs_to :artist

	delegate :name, to: :artist, prefix: true

	has_many :tracks, dependent: :destroy

	def find_youtube_playlist_id
		search_query = self.artist_name + " " + self.title
	
		result = query_youtube_api(search_query, "playlist")

		return nil if result.nil?
		result['playlistId']		
	end

	def populate_tracks_from_youtube_playlist
		return nil if self.youtube_playlist_id.nil?
		
		uri = URI("https://youtube.googleapis.com/youtube/v3/playlistItems?part=snippet&maxResults=5000&playlistId=#{self.youtube_playlist_id}&key=#{YOUTUBE_API_KEY}")
		response = Net::HTTP.get(uri)
		parsed_response = JSON.parse(response)

		parsed_response["items"].each do |item|
			next if !Track.find_by(title: item["snippet"]["title"]).nil?
			Track.create!(title: item["snippet"]["title"], album_id: self.id)
		end
	end

	def populate_tracks_from_spotify_api
		retries = 0
		begin
			RSpotify::authenticate(SPOTIFY_CLIENT_ID, SPOTIFY_CLIENT_SECRET)
			search_results = RSpotify::Album.search(self.title)
		rescue
			retries += 1
			if retries < 3
				retry
			else
				return nil
			end
		end
		
		tracks = search_results.first.tracks
		tracks.each do |track|
			Track.create!(title: track.name, album_id: self.id)
		end
	end
end
