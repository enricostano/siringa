module Siringa

  @definitions = {}

  class << self
    attr_accessor :configuration
  end

  def self.configuration
    @configuration ||= Configuration.new
  end

  def self.configure
    yield(configuration)
  end

  class Configuration
    attr_accessor :definitions_path, :dumps_path

    def initialize
      @definitions_path = "spec/siringa"
      @dumps_path = 'tmp/dumps'
    end
  end

end
