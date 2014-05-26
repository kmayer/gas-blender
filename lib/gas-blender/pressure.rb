module GasBlender
  class Pressure
    CONVERSION_TOLERANCE = 0.000_001

    def initialize(magnitude)
      @magnitude = magnitude.to_f
      freeze
    end

    def inspect
      "%.6f" % magnitude
    end

    protected

    attr_reader :magnitude
  end

  class Bar < Pressure
    def to_s
      "%.1f bar" % magnitude
    end

    def ==(other)
      other.respond_to?(:to_bar) && (magnitude - other.to_bar.magnitude) < CONVERSION_TOLERANCE
    end

    def to_bar
      self
    end

    def to_psi
      PSI.new(magnitude * 14.5038)
    end
  end

  class PSI < Pressure
    def to_s
      "%.1f psi" % magnitude
    end

    def ==(other)
      other.respond_to?(:to_psi) && (magnitude - other.to_psi.magnitude) < CONVERSION_TOLERANCE
    end

    def to_psi
      self
    end

    def to_bar
      Bar.new(magnitude * 0.0689474)
    end
  end
end