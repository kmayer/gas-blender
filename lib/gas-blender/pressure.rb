module GasBlender
  class Pressure
    include Comparable

    PRECISION = 8

    def initialize(magnitude)
      @magnitude = magnitude.to_f
      freeze
    end

    def inspect
      "%.#{PRECISION}f" % magnitude
    end

    def <=>(other)
      other = GasBlender::Pressure(other)
      magnitude.round(PRECISION) <=> other.send(converter).magnitude.round(PRECISION)
    end

    def hash
      [magnitude, self.class].hash
    end

    alias_method :eql?, :==

    def zero?
      magnitude.round(PRECISION) == 0.0
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

    protected

    attr_reader :magnitude
  end

  class Bar < Pressure
    def to_s
      "%.#{PRECISION}f bar" % magnitude
    end

    def converter
      :to_bar
    end

    def to_bar
      self
    end

    def to_psi
      PSI.new(magnitude * 14.5037738)
    end
  end

  class PSI < Pressure
    def to_s
      "%.#{PRECISION}f psi" % magnitude
    end

    def converter
      :to_psi
    end

    def to_psi
      self
    end

    def to_bar
      Bar.new(magnitude * 0.0689475729)
    end
  end
end