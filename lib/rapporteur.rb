# frozen_string_literal: true

require 'rapporteur/engine' if defined?(Rails)
require 'rapporteur/version'

# Rapporteur is a Rails Engine which provides your application with an
# application status endpoint.
#
module Rapporteur
  autoload :CheckList, 'rapporteur/check_list'
  autoload :Checker, 'rapporteur/checker'
  autoload :CheckerDeprecations, 'rapporteur/checker_deprecations'
  autoload :Checks, 'rapporteur/checks'
  autoload :MessageList, 'rapporteur/message_list'
  autoload :Revision, 'rapporteur/revision'

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
  #   Rapporteur.add_check { |checker|
  #     checker.add_error("Bad luck.") if rand(2) == 1
  #   }
  #
  # Returns the Checker instance.
  # Raises ArgumentError if the given check does not respond to call.
  #
  def self.add_check(object_or_nil_with_block = nil, &block)
    checker.add_check(object_or_nil_with_block, &block)
  end

  # Internal: The Checker instance. All toplevel calls on Rapporteur are
  # delgated to this object.
  #
  def self.checker
    unless @checker
      @checker = Checker.new
      add_check(Checks::RevisionCheck)
      add_check(Checks::TimeCheck)
    end
    @checker
  end
  @checker = nil

  # Public: Empties all configured checks from the checker. This may be
  # useful for testing and for cases where you might've built up some basic
  # checks but for one reason or another (environment constraint) need to
  # start from scratch.
  #
  # Returns the Checker instance.
  #
  def self.clear_checks
    checker.clear
  end

  # Public: This is the primary execution point for this class. Use run to
  # exercise the configured checker and collect any application errors or
  # data for rendering.
  #
  # Returns the Checker instance.
  #
  def self.run
    checker.run
  end
end
