module Siringa

  # Load definitions from files
  def self.load_definitions
    Dir[Rails.root.join("#{self.configuration.definitions_path}/**/*.rb")].each { |f| require f }
  end

  # Load a definition and run its code
  #
  # @param [Symbol] name of the definition
  # @param [Hash] arguments of the definition
  def self.load_definition(name, options)
    if exists_definition?(name)
      @definitions[name].call(options)
    else
      raise ArgumentError, "Definition #{name.to_s} does not exist.", caller
    end
  end

  # Add a definition
  #
  # @param [Symbol] name of the definition
  # @param [Proc] code to run
  def self.add_definition(name, &block)
    if !exists_definition?(name)
      @definitions[name] = Proc.new(&block)
    else
      raise ArgumentError, "Definition #{name.to_s} already exists."
    end
  end

  # Check if a definition already exists
  #
  # @param  [Symbol] name of the definition
  # @return [Boolean]
  def self.exists_definition?(name)
    !@definitions[name].nil?
  end
end
