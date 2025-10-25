class CreateStories < ActiveRecord::Migration[8.0]
  def change
    create_table :stories do |t|
      t.string :title
      t.text :content
      t.string :status

      t.timestamps
    end
  end
end
