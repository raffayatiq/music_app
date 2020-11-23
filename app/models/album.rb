class Album < ApplicationRecord
	validates :title, :year, presence: true
	validates :version, inclusion: { in: [true, false] }
	validates :artist_id, uniqueness: { scope: :title}
	validates :year, numericality: { greater_than: 1900, less_than: 9000 }
	after_initialize :set_defaults

	def version_non_boolean
		self.version ? "Studio" : "Live"
	end

	belongs_to :artist

	delegate :name, to: :artist, prefix: true

	has_many :tracks, dependent: :destroy

	def find_youtube_playlist_id
		search_query = self.artist_name + " " + self.title
	
		result = query_youtube_api(search_query)

		return nil if result.nil?
		result['playlistId']		
	end

	private
	def set_defaults
		self.version ||= false
	end
end
