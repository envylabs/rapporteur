module Rapporteur
  class Revision
    class_attribute :_current

    def self.current
      self._current ||= calculate_current
    end

    def self.current=(revision)
      self._current = calculate_current(revision)
    end

    def self.default_revision_source
      `git rev-parse HEAD 2>/dev/null`.strip
    rescue
    end

    def self.calculate_current(revision = default_revision_source)
      case revision
      when String
        revision
      when Proc
        revision.call
      when NilClass
        "You must provide a Rapporteur::Revision.current= String or Proc"
      else
        raise ArgumentError, "Unknown revision type given: #{revision.inspect}"
      end
    end
  end
end
