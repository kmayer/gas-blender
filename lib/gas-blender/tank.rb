module GasBlender
  class Tank
    attr_reader :service_pressure
    attr_reader :current_pressure
    attr_reader :current_mix

    def initialize(attributes = {})
      @service_pressure = attributes.delete(:service_pressure)
      @current_pressure = attributes.delete(:current_pressure) || service_pressure.class.new(0)
      @current_mix = attributes.delete(:current_mix) || 0.21
      raise RuntimeError, "Invalid attributes: #{attributes.keys.inspect}" unless attributes == {}
    end
  end
end