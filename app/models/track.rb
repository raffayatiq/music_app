require 'open-uri'
require 'yt'
require 'json'
require 'net/http'

class Track < ApplicationRecord
	YOUTUBE_API_KEY = 'AIzaSyAzwGhEYWBJKUbTHiBUOh40NoJRa61BMBo'

	validates :title, presence: true

	belongs_to :album

	delegate :artist_name, to: :album

	def find_lyrics
		link_formatted_track_artist = self.album.artist.name.split(Regexp.union([" ", "'"])).join("-")
		link_formatted_track_title = self.title.split(Regexp.union([" ", "'"])).join("-")

		retries = 0
		begin
			html = open("https://www.musixmatch.com/lyrics/#{link_formatted_track_artist}/#{link_formatted_track_title}")
		rescue
			retries += 1
			if retries < 3
				retry
			else
				return ""
			end
		end

		doc = Nokogiri::HTML(html)
		lyrics = doc.css(".lyrics__content__ok").text
	end

	def find_video_id
		search_query = self.artist_name + " " + self.title
		
		uri = URI("https://www.googleapis.com/youtube/v3/search?key=#{YOUTUBE_API_KEY}&q=#{search_query}&part=snippet,id&order=relevance&maxResults=1")

		response = Net::HTTP.get(uri)
		parsed_response =  JSON.parse(response)

		parsed_response['items'].first['id']['videoId']		
	end
end