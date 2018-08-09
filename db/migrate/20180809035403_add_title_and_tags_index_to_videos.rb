class AddTitleAndTagsIndexToVideos < ActiveRecord::Migration[5.2]
  def change
    add_index :videos, :title
    add_index :videos, :tags
  end
end
