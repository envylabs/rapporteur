require 'singleton'
require 'set'

module Rapporteur
  # The center of the Rapporteur library, Checker manages holding and running
  # the custom checks, holding any application error messages, and provides the
  # controller with that data for rendering.
  #
  class Checker
    include Singleton
    include ActiveModel::Validations
    include ActiveModel::SerializerSupport


    # Public: Add a pre-built or custom check to your status endpoint. These
    # checks are used to test the state of the world of the application, and
    # need only respond to `#call`.
    #
    # Once added, the given check will be called and passed an instance of this
    # checker. If everything is good, do nothing! If there is a problem, use
    # `add_error` to add an error message to the checker.
    #
    # Examples
    #
    #   Rapporteur::Checker.add_check(lambda { |checker|
    #     checker.add_error("Bad luck.") if rand(2) == 1
    #   })
    #
    # Returns Rapporteur::Checker.
    # Raises ArgumentError if the given check does not respond to call.
    #
    def self.add_check(object)
      raise ArgumentError, "A check must respond to #call." unless object.respond_to?(:call)
      instance.checks << object
      self
    end

    # Public: Empties all configured checks from the checker. This may be
    # useful for testing and for cases where you might've built up some basic
    # checks but for one reason or another (environment constraint) need to
    # start from scratch.
    #
    # Returns Rapporteur::Checker.
    #
    def self.clear
      instance.checks.clear
      self
    end

    # Public: This is the primary execution point for this class. Use run to
    # exercise the configured checker and collect any application errors or
    # data for rendering.
    #
    # Returns a Rapporteur::Checker instance.
    #
    def self.run
      instance.errors.clear
      instance.run
    end


    # Public: Add an error message to the checker in order to have it rendered
    # in the status request.
    #
    # It is suggested that you use I18n and locale files for these messages, as
    # is done with the pre-built checks. If you're using I19n, you'll need to
    # define `activemodel.errors.models.rapporteur/checker.attributes.base.<your key>`.
    #
    # Examples
    #
    #   checker.add_error("You failed.")
    #   checker.add_error(:i18n_key_is_better)
    #
    # Returns the Rapporteur::Checker instance.
    #
    def add_error(message)
      errors.add(:base, message)
      self
    end

    # Public: Returns the Set of checks currently configured.
    #
    def checks
      @checks ||= Set.new
    end

    # Public: Returns a String containing the current revision of the
    # application.
    #
    def revision
      Revision.current
    end

    # Public: Executes the configured checks.
    #
    # Returns the Rapporteur::Checker instance.
    #
    def run
      checks.each do |object|
        object.call(self)
      end
      self
    end

    # Public: Returns a Time instance containing the current system time.
    #
    def time
      Time.now
    end
  end
end
