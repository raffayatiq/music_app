class RemoveVersionColumnFromAlbums < ActiveRecord::Migration[5.2]
  def up
  	remove_column :albums, :version
  end

  def down
  	add_column :albums, :version, null: false, default: false 
  end
end
