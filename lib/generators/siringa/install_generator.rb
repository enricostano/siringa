module Siringa
  module Generators
    class InstallGenerator < Rails::Generators::Base
      desc "Creates tmp/dumps folder to store Siringa dumps"

      def create_dumps_folder
        empty_directory "tmp/dumps"
      end
    end
  end
end
