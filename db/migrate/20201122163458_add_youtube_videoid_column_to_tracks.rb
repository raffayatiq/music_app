class AddYoutubeVideoidColumnToTracks < ActiveRecord::Migration[5.2]
  def change
  	add_column :tracks, :video_id, :string
  end
end
