class ApplicationRecord < ActiveRecord::Base
  self.abstract_class = true
  YOUTUBE_API_KEY = 'AIzaSyAzwGhEYWBJKUbTHiBUOh40NoJRa61BMBo'.freeze
  SPOTIFY_CLIENT_ID = 'dbcdc162ff6d494787cfaff2ce5fd49a'.freeze
  SPOTIFY_CLIENT_SECRET = '6912fdf88ef0471d8829c8d05f39ebd4'.freeze
  RSpotify::authenticate("SPOTIFY_CLIENT_ID", "SPOTIFY_CLIENT_SECRET")

  def query_youtube_api(search_query)
  	country_code = get_country_code
  	search_query += "&regionCode=#{country_code}" if country_code

  	retries = 0
	begin		
		uri = URI("https://www.googleapis.com/youtube/v3/search?key=#{YOUTUBE_API_KEY}&q=#{search_query}&part=snippet,id&order=relevance&maxResults=1")
	rescue
		retries += 1
		if retries < 3
			retry
		else
			return nil
		end
	end

	def get_album_names_from_spotify_api(artist)
		#ALSO FETCH ALBUM RELEASE DATE TO POPULATE AN ALBUMS YEAR, DO NOT REMOVE THE YEAR COLUMN.
		search_results = RSpotify::Artist.search(artist.name)
		artist = search_results.first
		album_names = artist.albums.map { |album| album.name }
		album_names.each { |name| name.slice! " (Deluxe)"}
		album_names
	end

	response = Net::HTTP.get(uri)
	parsed_response =  JSON.parse(response)
	search_results = parsed_response['items']

	return nil if search_results.nil? || search_results.empty?
	search_results.first['id']
  end

	def get_country_code
		public_ip_address = open('http://whatismyip.akamai.com').read

		response = Net::HTTP.get( URI.parse( "https://www.iplocate.io/api/lookup/#{public_ip_address}" ) )
		JSON.parse(response)["country_code"]
	end
end
