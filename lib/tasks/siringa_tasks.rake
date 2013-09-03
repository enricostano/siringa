namespace :siringa do
  desc "Load a definition and populate the DB with seed data"
  task :load, [:definition] do |t, args|
    args.with_defaults :definition => :initial
    Rake::Task["environment"].invoke
    puts <<-EOS
    This will load #{args[:definition]} definition and populate the DB for #{Rails.env} environment.
    EOS
    Siringa.load_definition(args[:definition].to_sym)
  end
end
