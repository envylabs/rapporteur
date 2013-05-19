module Rapporteur
  class Responder < ActionController::Responder
    def to_format
      if has_errors?
        display_errors
      else
        super
      end
    end


    protected


    if Rails::VERSION::MAJOR == 3 && Rails::VERSION::MINOR == 1
      def display_errors
        controller.render format => {errors: resource.errors}, status: :internal_server_error
      end
    elsif Rails::VERSION::MAJOR == 3 && Rails::VERSION::MINOR == 2
      def display_errors
        controller.render format => resource_errors, status: :internal_server_error
      end
    end
  end
end
