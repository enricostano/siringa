module Siringa
  class SiringaController < ApplicationController

    # TODO: deprecate in 0.1.0
    #
    def load
      Rails.logger.warn '[Siringa] Using /load route has been deprecated in favour of /load_definition. Will be dropped in 0.1.0'

      load_definition
    end

    def load_definition
      result = Siringa.load_definition(params['definition'].to_sym, options)
      render json: result, status: :created
    rescue ArgumentError => exception
      render json: { error: exception.to_s }, status: :method_not_allowed
    rescue StandardError => exception
      render json: { error: exception.to_s }, status: :internal_server_error
    end

    def dump
      Siringa.keep_five_dumps(Siringa.ordered_dumps)
      result = Siringa.dump_to(Siringa.dump_file_name)
      if result[:status]
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
        if result[:status]
          resp = { :text => "DB restored from #{result[:dump_path]}",
                   :status => :accepted }
        else
          resp = { :text => "DB restore FAILED!\nError:\n#{result[:error]}",
                   :status => :internal_server_error }
        end
      else
        resp = { :text => "DB restore FAILED!\nThere is no dump to restore from.",
                 :status => :method_not_allowed }
      end

      render resp
    end

    private

    # Returns the arguments to be passed to the definition
    #
    # @return [Hash] arguments of the definition
    def options
      params[:siringa_args]
    end
  end
end
