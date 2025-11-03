# Database backup tasks
require 'English'
namespace :db do # rubocop:disable Metrics/BlockLength
  namespace :backup do # rubocop:disable Metrics/BlockLength
    desc 'Create a backup of the development database'
    task create: :environment do
      next unless Rails.env.development?

      timestamp = Time.current.strftime('%Y%m%d_%H%M%S')
      backup_dir = Rails.root.join('db/backups')
      FileUtils.mkdir_p(backup_dir)

      backup_file = backup_dir.join("#{Rails.env}_#{timestamp}.dump")

      config = Rails.configuration.database_configuration[Rails.env]
      cmd = "pg_dump -Fc -v -h #{config['host'] || 'localhost'} " \
            "-U #{config['username']} -d #{config['database']} -f #{backup_file}"

      puts "Creating database backup: #{backup_file}"
      system(cmd)

      if $CHILD_STATUS.success?
        puts "✓ Backup created successfully: #{backup_file}"

        # Keep only last 10 backups
        backups = Dir.glob(backup_dir.join('*.dump'))
        if backups.length > 10
          old_backups = backups[0...-10]
          old_backups.each do |old_backup|
            File.delete(old_backup)
            puts "Deleted old backup: #{old_backup}"
          end
        end
      else
        puts '✗ Backup failed'
        exit 1
      end
    end

    desc 'List all database backups'
    task list: :environment do
      backup_dir = Rails.root.join('db/backups')
      backups = Dir.glob(backup_dir.join('*.dump')).reverse

      if backups.empty?
        puts "No backups found in #{backup_dir}"
      else
        puts 'Available backups:'
        backups.each_with_index do |backup, i|
          size = File.size(backup) / 1024.0 / 1024.0
          puts "  #{i + 1}. #{File.basename(backup)} (#{size.round(2)} MB) - #{File.mtime(backup)}"
        end
      end
    end

    desc 'Restore database from backup (usage: rake db:backup:restore[backup_filename])'
    task :restore, [:filename] => :environment do |_t, args| # rubocop:disable Metrics/BlockLength
      unless Rails.env.development?
        puts '✗ Restore only allowed in development environment'
        exit 1
      end

      backup_dir = Rails.root.join('db/backups')
      backup_file = backup_dir.join(args[:filename])

      unless File.exist?(backup_file)
        puts "✗ Backup file not found: #{backup_file}"
        puts 'Available backups:'
        Rake::Task['db:backup:list'].invoke
        exit 1
      end

      puts '⚠️  WARNING: This will replace your current database!'
      puts "Restoring from: #{backup_file}"
      print "Type 'yes' to continue: "

      confirmation = $stdin.gets.chomp
      unless confirmation == 'yes'
        puts 'Restore cancelled'
        exit 0
      end

      config = Rails.configuration.database_configuration[Rails.env]
      cmd = "pg_restore -c -v -h #{config['host'] || 'localhost'} " \
            "-U #{config['username']} -d #{config['database']} #{backup_file}"

      puts 'Restoring database...'
      system(cmd)

      if $CHILD_STATUS.success?
        puts '✓ Database restored successfully'
      else
        puts '✗ Restore failed'
        exit 1
      end
    end
  end

  # Auto-backup before dangerous operations
  %w[reset drop].each do |task_name|
    task task_name => 'db:backup:create' if Rails.env.development?
  end
end
