# config/initializers/siringa.rb
Siringa.configure do |config|
  # customize the path where the definitions are stored
  # config.definitions_path = 'test/siringa'
  # customize the path where the dumps are stored
  # config.dumps_path = 'tmp/dumps'
end

Siringa.load_definitions
