module Rapporteur
  module Checks
    autoload :ActiveRecordCheck, 'rapporteur/checks/active_record_check'

    # A check which simply reports the current clock time in UTC. This check is
    # useful because it shows that the status end point is not being cached and
    # allows you to determine if your server clocks are abnormally skewed.
    #
    # This check has no failure cases.
    #
    # Examples
    #
    #   {
    #     time: "2013-06-21T05:18:59Z"
    #   }
    #
    TimeCheck = lambda { |checker| checker.add_message(:time, Time.now.utc) }

    # A check which reports the current revision of the running application.
    #
    # This check has no failure cases.
    #
    # Examples
    #
    #   {
    #     revision: "c74edd04f64b25ff6691308bcfdefcee149aa4b5"
    #   }
    #
    RevisionCheck = lambda { |checker| checker.add_message(:revision, Revision.current) }
  end
end
