module Rapporteur
  module Checks
    autoload :ActiveRecordCheck, 'rapporteur/checks/active_record_check'

    TimeCheck = lambda { |checker| checker.add_message(:time, Time.now.utc) }
    RevisionCheck = lambda { |checker| checker.add_message(:revision, Revision.current) }
  end
end
