class Album < ApplicationRecord
	validates :title, :year, presence: true
	validates :version, inclusion: { in: [true, false] }
	validates :band_id, uniqueness: { scope: :title}
	validates :year, numericality: { greater_than: 1900, less_than: 9000 }
	after_initialize :set_defaults

	def version_non_boolean
		self.version ? "Studio" : "Live"
	end

	belongs_to :band

	delegate :name, to: :band, prefix: true

	has_many :tracks

	private
	def set_defaults
		self.version ||= false
	end
end
