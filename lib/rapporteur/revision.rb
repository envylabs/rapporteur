module Rapporteur
  # Manages memoizing and maintaining the current application revision.
  #
  class Revision
    class_attribute :_current

    # Public: Returns the current revision as a String.
    #
    def self.current
      self._current ||= calculate_current
    end

    # Public: Forcibly sets the current application revision.
    #
    # revision - Either a String or a callable object (Proc, for example) to
    #            use your own environment logic to determine the revision.
    #
    # Examples
    #
    #   Rapporteur::Revision.current = ENV['REVISION'].strip
    #   Rapporteur::Revision.current = Rails.root.join("REVISION").read.strip
    #
    # Returns the revision given.
    #
    def self.current=(revision)
      self._current = calculate_current(revision)
    end

    # Internal: The default method of determining the current revision. This
    # assumes a git executable is in the current PATH and that the process
    # context is running the the appropriate git application directory.
    #
    # Returns a String containing the current git revision, hopefully.
    #
    def self.default_revision_source
      `git rev-parse HEAD 2>/dev/null`.strip
    rescue
    end

    # Internal: Calculates the current revision from the configured revision
    # source.
    #
    def self.calculate_current(revision = default_revision_source)
      case revision
      when String
        revision
      when Proc
        revision.call.to_s
      when NilClass
        "You must provide a Rapporteur::Revision.current= String or Proc"
      else
        raise ArgumentError, "Unknown revision type given: #{revision.inspect}"
      end
    end
  end
end
