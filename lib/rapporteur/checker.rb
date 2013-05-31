require 'set'

module Rapporteur
  # The center of the Rapporteur library, CheckerClass manages holding and running
  # the custom checks, holding any application error messages, and provides the
  # controller with that data for rendering.
  #
  class CheckerClass
    include ActiveModel::Validations


    def initialize(checks=[])
      @messages = Hash.new
      @checks = Set.new
      reset
      checks.each { |check| add_check(check) }
    end


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
    #   Rapporteur::Checker.add_check { |checker|
    #     checker.add_error("Bad luck.") if rand(2) == 1
    #   }
    #
    # Returns Rapporteur::Checker.
    # Raises ArgumentError if the given check does not respond to call.
    #
    def add_check(object_or_nil_with_block=nil, &block)
      if block_given?
        @checks << block
      elsif object_or_nil_with_block.respond_to?(:call)
        @checks << object_or_nil_with_block
      else
        raise ArgumentError, "A check must respond to #call."
      end
      self
    end

    # Public: Empties all configured checks from the checker. This may be
    # useful for testing and for cases where you might've built up some basic
    # checks but for one reason or another (environment constraint) need to
    # start from scratch.
    #
    # Returns Rapporteur::Checker.
    #
    def clear
      @checks.clear
      self
    end

    ##
    # Public: Checks can call this method to halt any further processing. This
    # is useful for critical or fatal check failures.
    #
    # For example, if load is too high on a machine you may not want to run any
    # other checks.
    #
    # Returns true.
    #
    def halt!
      @halted = true
    end

    # Public: This is the primary execution point for this class. Use run to
    # exercise the configured checker and collect any application errors or
    # data for rendering.
    #
    # Returns a Rapporteur::CheckerClass instance.
    #
    def run
      reset
      @checks.each do |object|
        object.call(self)
        break if @halted
      end
      self
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
    # Returns the Rapporteur::CheckerClass instance.
    #
    def add_error(key, message, options={})
      options[:scope] = [:rapporteur, :errors, key]
      options[:default] = [message, message.to_s.humanize]
      errors.add(key, message, options)
      self
    end

    ##
    # Public: Adds a status message for inclusion in the success response.
    #
    # name - A String containing the name or identifier for your message. This
    #        is unique and may be overriden by other checks using the name
    #        message name key.
    # message - A String or Numeric for the value of the message.
    #
    # Examples
    #
    #   checker.add_message(:repository, 'git@github.com/user/repo.git')
    #   checker.add_message(:load, 0.934)
    #
    # Returns the Rapporteur::CheckerClass instance.
    #
    def add_message(name, message)
      @messages[name] = message
      self
    end

    ##
    # Internal: Returns a hash of messages suitable for conversion into JSON.
    #
    def as_json(args={})
      @messages
    end

    ##
    # Internal: Used by Rails' JSON serialization, specifically in
    # ActionController::Responder.
    #
    def read_attribute_for_serialization(key)
      @messages[key]
    end

    alias read_attribute_for_validation read_attribute_for_serialization


    private


    def reset
      @halted = false
      @messages.clear
      errors.clear
    end
  end

  Checker = CheckerClass.new([
    Checks::TimeCheck,
    Checks::RevisionCheck
  ])
end
