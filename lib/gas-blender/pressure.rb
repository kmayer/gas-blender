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

    def ==(other)
      other.respond_to?(converter) && (magnitude - other.send(converter).magnitude) < CONVERSION_TOLERANCE
    end

    def zero?
      magnitude.abs < CONVERSION_TOLERANCE
    end

    def -(other)
      other = GasBlender::Pressure(other)
      self.class.new(magnitude - other.send(converter).magnitude)
    end

    def +(other)
      other = GasBlender::Pressure(other)
      self.class.new(magnitude + other.send(converter).magnitude)
    end

    def *(factor)
      self.class.new(magnitude * factor.to_f)
    end

    def /(denominator)
      if denominator.class == self.class
        magnitude / denominator.magnitude.to_f
      else
        self.class.new(magnitude / denominator.to_f)
      end
    end

    def abs
      self.class.new(magnitude.abs)
    end

    def <=>(other)
      other = GasBlender::Pressure(other)
      magnitude - other.send(converter).magnitude
    end

    def <=(other)
      (self <=> other) <= 0.0
    end

    protected

    attr_reader :magnitude
  end

  class Bar < Pressure
    def to_s
      "%.1f bar" % magnitude
    end

    def converter
      :to_bar
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

    def converter
      :to_psi
    end

    def to_psi
      self
    end

    def to_bar
      Bar.new(magnitude * 0.0689474)
    end
  end
end