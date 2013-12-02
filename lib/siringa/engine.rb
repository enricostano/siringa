module Siringa
  class Engine < Rails::Engine
    isolate_namespace Siringa

    config.after_initialize do
      Siringa.load_definitions
    end
  end
end
