class Artist < ApplicationRecord
	validates :name, presence: true

	has_many :albums, dependent: :destroy

	has_many :tracks,
		through: :albums,
		source: :tracks,
		dependent: :destroy

	def populate_albums
		album_data = get_album_data_from_spotify_api
		return nil if album_data.nil?

		album_data.each do |datum|
			Album.create! title: datum.first,year: datum.second, artist_id: self.id
		end
	end

	private	
	def get_album_data_from_spotify_api
		retries = 0
		begin
			RSpotify::authenticate(SPOTIFY_CLIENT_ID, SPOTIFY_CLIENT_SECRET)
			search_results = RSpotify::Artist.search(self.name)
		rescue
			retries += 1
			if retries < 3
				retry
			else
				return nil
			end
		end
		data_point_of_interest = search_results.first
		album_data = data_point_of_interest.albums.map { |album| [album.name.split(" (Deluxe)").first, 
			album.release_date.split("-")[0]] }

		album_data.sort_by! { |datum| datum.second } # sort albums in year ASC
		album_data.uniq! { |datum| datum.first }
	end
end
