class Artist < ApplicationRecord
	validates :name, presence: true

	has_many :albums, dependent: :destroy

	has_many :tracks,
		through: :albums,
		source: :tracks,
		dependent: :destroy

	def populate_albums
		album_names = get_album_names_from_spotify_api(self)
	end
end
