class Remove < ActiveRecord::Migration[5.2]
  def up
  	remove_column :tracks, :track_type
  end

  def down
  	add_column :tracks, :track_type, :boolean, null: false, default: false
  end
end
