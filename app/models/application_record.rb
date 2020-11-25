class ApplicationRecord < ActiveRecord::Base
  self.abstract_class = true
  YOUTUBE_API_KEY = '[REDACTED]'.freeze
  SPOTIFY_CLIENT_ID = '[REDACTED]'.freeze
  SPOTIFY_CLIENT_SECRET = '[REDACTED]'.freeze

  def query_youtube_api(search_query, type)
  	# Disabled until YouTube API bug is fixed
  	# country_code = get_country_code
  	# search_query += "&regionCode=#{country_code}" if country_code
  	search_query += "&type=#{type}"

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
