module Rapporteur
  # A customization of the default Rails ActionController::Responder.
  # Primarily, this is used to smooth out the differences between Rails
  # responder versions and allow for error messages in GET requests.
  #
  class Responder < ActionController::Responder
    # Internal: Overrides the default behavior by ignoring the HTTP verb and
    # always responding with errors if the rendering resource contains errors.
    #
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
    else
      def display_errors
        controller.render format => resource_errors, status: :internal_server_error
      end
    end
  end
end
