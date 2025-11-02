class RemovePublishedAtFromPrintables < ActiveRecord::Migration[8.1]
  disable_ddl_transaction!

  def up
    # Ignore the column during the migration process to prevent runtime errors
    Printable.ignored_columns += [:published_at] if defined?(Printable)
    
    remove_column :printables, :published_at, :datetime
  end

  def down
    add_column :printables, :published_at, :datetime
  end
end
