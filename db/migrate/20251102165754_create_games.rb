class CreateGames < ActiveRecord::Migration[8.1]
  def change
    create_table :games do |t|
      t.string :title
      t.text :description
      t.string :game_url
      t.string :source_attribution
      t.string :status

      t.timestamps
    end
  end
end
