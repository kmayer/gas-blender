module GasBlender
  class Measure
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
      other.is_a?(self.class) && magnitude <=> other.magnitude
    end
    alias_method :eql?, :==

    def hash
      [magnitude, self.class].hash
    end

    def -(other)
      raise TypeError, "#{other.inspect} is not a #{self.class}" unless other.is_a?(self.class)
      self.class.new(magnitude - other.magnitude)
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

    def zero?
      magnitude.round(PRECISION) == 0.0
    end

    protected

    attr_reader :magnitude
  end
end