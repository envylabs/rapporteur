# frozen_string_literal: true

module Rapporteur
  module Checks
    class ActiveRecordCheck
      def self.call(checker)
        ActiveRecord::Base.connection.select_value('SELECT current_time AS time')
      rescue
        checker.add_error(:database, :unavailable)
      end
    end
  end
end
