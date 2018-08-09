class AddTagsToVideos < ActiveRecord::Migration[5.2]
  def change
    add_column :videos, :tags, :string, array: true
  end
end
