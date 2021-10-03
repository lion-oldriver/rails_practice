class CreateBlogFiles < ActiveRecord::Migration[5.2]
  def change
    create_table :blog_files do |t|
      t.references :blog
      t.string :file

      t.timestamps
    end
  end
end
