class RenameBandsToArtists < ActiveRecord::Migration[5.2]
  def change
  	rename_table :bands, :artists
  end
end
