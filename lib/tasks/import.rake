namespace :import do
  desc "Send destroy_all to Activity Criterium CollaboratingAgency State"
  task :reset => [:environment] do
    include ActionView::Helpers::TextHelper
    %w(Activity Criterium CollaboratingAgency State).each do |cls|
      puts "Deleted #{pluralize(cls.constantize.send(:destroy_all).size, cls)}"
    end
  end
  namespace :csv do
    desc "Import data from a CSV file"
    task :activity, [:filename] => [:environment] do |t, args|
      begin
        require 'fastercsv'
      rescue LoadError
        puts "Missing at least one of fastercsv gem"
        quit
      end

      filepath = File.join(Rails.root, args[:filename])

      raise "File not found at #{filepath}" unless File.exists?(filepath)
      raise "File not readable at #{filepath}" unless File.readable?(filepath)

      puts "Importing #{args[:filename]}"
      file = File.new(filepath, 'r').readlines
      entry_count = file.size - 2
      puts "Entries found: #{entry_count}"

      #target_class = file.first.split(',')[1].gsub(/"/, '')

      #unless defined?(target_class)
      #  require target_class.downcase
      #end

      #target_class = target_class.constantize

      pre_import_count = Activity.count
      puts "Pre-import Activity count: #{pre_import_count}"
      Activity.legacy_csv_import(filepath)
      post_import_count = Activity.count
      puts "Post-import Activity count: #{post_import_count}"
      puts "Added: #{post_import_count - pre_import_count}"
      puts "Omitted: #{entry_count - (post_import_count - pre_import_count)}"
    end
  end
end

