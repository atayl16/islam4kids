class CreatePrintables < ActiveRecord::Migration[8.1]
  def change
    create_table :printables do |t|
      t.string :title
      t.text :description
      t.string :printable_type
      t.boolean :published
      t.datetime :published_at

      t.timestamps
    end
  end
end
