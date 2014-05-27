require_relative "measure"

module GasBlender
  class Length < Measure
  end

  class Feet < Length
    def to_s
      "%.#{PRECISION}f feet" % magnitude
    end
  end
  class Meter < Length
    def to_s
      "%.#{PRECISION}f m" % magnitude
    end
  end
end