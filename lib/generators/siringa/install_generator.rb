module Siringa
  module Generators
    class InstallGenerator < Rails::Generators::Base
      source_root File.expand_path("../../templates", __FILE__)
      desc "Creates Siringa initializer for your application"

      def copy_initializer
        template "siringa_initializer.rb", "config/initializers/siringa.rb"

        puts "Install complete!"
      end

      def create_dumps_folder
        empty_directory "tmp/dumps"
      end
    end
  end
end
