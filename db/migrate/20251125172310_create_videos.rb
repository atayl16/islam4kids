class CreateVideos < ActiveRecord::Migration[8.1]
  def change
    create_table :videos do |t|
      t.string :title, null: false
      t.text :description
      t.string :video_url, null: false
      t.boolean :featured, default: false, null: false
      t.string :status, default: 'draft', null: false
      t.integer :position, default: 0, null: false

      t.timestamps
    end

    add_index :videos, :status
    add_index :videos, :featured
    add_index :videos, :position
  end
end
