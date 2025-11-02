class RemovePublishedAtFromPrintables < ActiveRecord::Migration[8.1]
  disable_ddl_transaction!

  def up
    remove_column :printables, :published_at, :datetime
  end

  def down
    add_column :printables, :published_at, :datetime
  end
end
