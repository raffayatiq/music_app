class AddYoutubePlaylistIdToAlbums < ActiveRecord::Migration[5.2]
  def change
  	add_column :albums, :youtube_playlist_id, :string
  end
end
