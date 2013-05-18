module Codeschool
  module Status
    class Responder < ActionController::Responder
      def to_format
        if has_errors?
          display_errors
        else
          super
        end
      end


      protected


      def display_errors
        controller.render format => resource_errors, status: :internal_server_error
      end
    end
  end
end
