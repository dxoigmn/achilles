namespace :db do
  desc 'Loads initial database models for the current environment.'
  task :populate => :environment do
    Dir[File.join(RAILS_ROOT, 'db', 'fixtures', '*.rb')].sort.each do |fixture|
      puts "Importing database fixture '#{File.basename(fixture)}'..."
      load fixture
    end

    Dir[File.join(RAILS_ROOT, 'db', 'fixtures', RAILS_ENV, '*.rb')].sort.each do |fixture|
      puts "Importing database fixture '#{File.basename(fixture)}'..."
      load fixture
    end
  end

  desc 'Rebuild the database from scratch'
  task :rebuild => :environment do
    Rake::Task['db:drop'].invoke
    Rake::Task['db:create'].invoke
    Rake::Task['db:schema:load'].invoke
    Rake::Task['db:populate'].invoke
  end
end
