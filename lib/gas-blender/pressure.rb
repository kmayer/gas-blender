require_relative "measure"

module GasBlender
  class Pressure < Measure
    def <=>(other)
      other = GasBlender::Pressure(other)
      magnitude.round(PRECISION) <=> other.send(converter).magnitude.round(PRECISION)
    end

    def -(other)
      other = GasBlender::Pressure(other)
      self.class.new(magnitude - other.send(converter).magnitude)
    end

    def +(other)
      other = GasBlender::Pressure(other)
      self.class.new(magnitude + other.send(converter).magnitude)
    end
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

  class ATM < Pressure
    def to_s
      "%.#{PRECISION}f atm" % magnitude
    end

    def to_fsw
      Feet.new(33) * self.magnitude
    end

    def to_msw
      Meter.new(10) * self.magnitude
    end
  end
end