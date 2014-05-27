module GasBlender
  class Mix
    include Comparable

    def initialize(magnitude)
      @magnitude = magnitude.to_f
      freeze
    end

    def to_f
      magnitude
    end

    def <=>(other)
      other.is_a?(self.class) && magnitude <=> other.magnitude
    end

    alias_method :eql?, :==

    def hash
      [magnitude, Mix].hash
    end

    def -(other)
      raise TypeError, "#{other.inspect} is not a #{self.class}" unless other.is_a?(self.class)
      magnitude - other.magnitude
    end

    protected

    attr_reader :magnitude
  end
end