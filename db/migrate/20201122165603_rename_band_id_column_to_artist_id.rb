class RenameBandIdColumnToArtistId < ActiveRecord::Migration[5.2]
  def change
  	rename_column :albums, :band_id, :artist_id
  end
end
