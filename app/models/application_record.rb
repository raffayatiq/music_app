class ApplicationRecord < ActiveRecord::Base
  self.abstract_class = true
  YOUTUBE_API_KEY = 'AIzaSyAzwGhEYWBJKUbTHiBUOh40NoJRa61BMBo'.freeze

  def query_youtube_api(search_query)
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

	return nil if search_results.empty?
	search_results.first['id']
  end
end
