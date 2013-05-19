module Rapporteur
  # An ActiveModel::Serializer used to serialize the checker data for JSON
  # rendering.
  #
  class Serializer < ActiveModel::Serializer
    self.root = false

    attributes :revision,
               :time

    # Internal: Converts the checker instance time into UTC to provide a
    # consistent public representation.
    #
    # Returns a Time instance in UTC.
    #
    def time
      object.time.utc
    end
  end
end
