class DropBlogs < ActiveRecord::Migration[8.1]
  def change
    drop_table :blogs do |t|
      t.text :content
      t.datetime :created_at, null: false
      t.string :status
      t.string :title
      t.datetime :updated_at, null: false
    end
  end
end
