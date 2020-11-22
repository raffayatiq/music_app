class RemoveOrdColumnFromTracks < ActiveRecord::Migration[5.2]
  def up
  	remove_column :tracks, :ord
  end

  def down
  	add_column :tracks, :ord, :integer, null: false
  end
end
