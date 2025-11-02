class RemovePublishedAtFromPrintables < ActiveRecord::Migration[8.1]
  def change
    remove_column :printables, :published_at, :datetime
  end
end
