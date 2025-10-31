class AddStatusToPrintables < ActiveRecord::Migration[8.1]
  def up
    add_column :printables, :status, :string
    
    # Migrate existing published boolean to status enum
    # If published=true, set status='published'
    # If published=false or nil, set status='draft'
    execute <<-SQL
      UPDATE printables
      SET status = CASE
        WHEN published = true THEN 'published'
        ELSE 'draft'
      END
    SQL
    
    # Set default for future records
    change_column_default :printables, :status, 'draft'
  end

  def down
    # Migrate status back to published boolean before removing column
    execute <<-SQL
      UPDATE printables
      SET published = CASE
        WHEN status = 'published' THEN true
        ELSE false
      END
    SQL
    
    remove_column :printables, :status
  end
end
