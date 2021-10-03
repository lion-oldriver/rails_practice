class AddImageIdToBlogFiles < ActiveRecord::Migration[5.2]
  def change
    add_column :blog_files, :image_id, :string
  end
end
