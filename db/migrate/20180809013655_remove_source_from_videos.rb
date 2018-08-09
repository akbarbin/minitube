class RemoveSourceFromVideos < ActiveRecord::Migration[5.2]
  def change
    remove_column :videos, :source, :string
  end
end
