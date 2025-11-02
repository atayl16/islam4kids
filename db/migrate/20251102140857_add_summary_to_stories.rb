class AddSummaryToStories < ActiveRecord::Migration[8.1]
  def change
    add_column :stories, :summary, :text
  end
end
