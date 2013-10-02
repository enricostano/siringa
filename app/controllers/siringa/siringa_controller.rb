module Siringa
  class SiringaController < ApplicationController

    def load
      Siringa.load_definition(params['definition'].to_sym)
      resp = { :text => "Definition #{params['definition']} loaded.", :status => :created }
    rescue ArgumentError => exception
      resp = { :text => exception.to_s, :status => :method_not_allowed }
    rescue => exception
      resp = { :text => exception.to_s, :status => :internal_server_error }
    ensure
      render resp
    end

    def dump
      Siringa.keep_five_dumps(Siringa.ordered_dumps)
      result = Siringa.dump_to(Siringa.dump_file_name)
      if result[:success]
        resp = { :text => "DB dumped at #{result[:dump_path]}",
                 :status => :created }
      else
        resp = { :text => "DB dump FAILED!\nError:\n#{result[:error]}",
                 :status => :internal_server_error }
      end

      render resp
    end

    def restore
      last_dump = Siringa.ordered_dumps.last
      if last_dump
        result = Siringa.restore_from(last_dump)
        if result[:success]
          resp = { :text => "DB restored from #{result[:dump_path]}",
                   :status => :accepted }
        else
          resp = { :text => "DB restore FAILED!\nError:\n#{result[:output]}",
                   :status => :internal_server_error }
        end
      else
        resp = { :text => "DB restore FAILED!\nThere is no dump to restore from.",
                 :status => :method_not_allowed }
      end

      render resp
    end

  end
end
