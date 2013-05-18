module Codeschool
  module Status
    class Checker
      include ActiveModel::Validations
      include ActiveModel::SerializerSupport


      def self.check
        status = new
        status.check
        status
      end


      def check
        validate_database_connection
        self
      end

      def revision
        Revision.current
      end

      def time
        Time.now
      end


      private


      def validate_database_connection
        ActiveRecord::Base.connection.execute("SELECT current_time AS time").first.fetch('time')
      rescue
        errors.add(:base, :database_unavailable)
      end
    end
  end
end
