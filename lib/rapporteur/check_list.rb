# frozen_string_literal: true

module Rapporteur
  # Manages a list of checks.
  #
  # The goals of this object are to store and return the check objects given to
  # it in the same order they were given (in Ruby 1.8 and newer). And, to
  # ensure that the same check is not added twice to be run.
  #
  # Previously, a native Ruby Set was used. However, Sets do not guarantee
  # order, particularly in Ruby 1.8. A simple Array is possible, but loses the
  # uniqueness constraint of the objects added.
  #
  class CheckList
    # Public: Returns a new, empty CheckList instance.
    #
    def initialize
      @list = []
    end

    # Public: Add a new check to the list.
    #
    # Returns the CheckList instance.
    #
    def add(check)
      @list << check unless @list.include?(check)
      self
    end

    # Public: Empties all checks from the list. This functionally resets the
    # list to an initial state.
    #
    # Returns the CheckList instance.
    #
    def clear
      @list.clear
      self
    end

    # Public: Iterates over all of the contained objects and yields them out,
    # individually.
    #
    # Returns the CheckList instance.
    #
    def each(&block)
      @list.each(&block)
      self
    end

    # Public: Returns true if the list is empty.
    #
    def empty?
      @list.empty?
    end

    # Public: Returns the objects in the list in an Array.
    #
    def to_a
      @list.dup
    end
  end
end
