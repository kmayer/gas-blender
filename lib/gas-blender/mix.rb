require_relative "measure"

module GasBlender
  class Mix < Measure
    def to_f
      magnitude
    end
  end
end