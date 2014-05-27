module GasBlender
  class Fill
    attr_reader :mix
    attr_reader :tank
    attr_reader :fill_mix
    attr_reader :top_off_mix

    def initialize(attributes)
      @mix = attributes.delete(:mix) || Mix.new(0.21)
      @tank = attributes.delete(:tank)
      @fill_mix = attributes.delete(:fill_mix) || Mix.new(1.0)
      @top_off_mix = attributes.delete(:top_off_mix) || Mix.new(0.21)
      raise RuntimeError, "Invalid attributes: #{attributes.keys.inspect}" unless attributes == {}
    end

    def pressure
      if !pressure_need.zero?
        (pressure_need * ((fO2_need - top_off_mix) / (fill_mix - top_off_mix))) + pressure_have
      else
        (pressure_want * (fO2_want - top_off_mix)) / (fO2_have - top_off_mix)
      end
    end

    def mod(max_ppO2)
      case tank.service_pressure
      when GasBlender::PSI
        mod_fsw(max_ppO2)
      when GasBlender::Bar
        mod_msw(max_ppO2)
      else
        raise TypeError, "Unknown tank service pressure, #{tank.inspect}"
      end
    end

    def mod_fsw(max_ppO2)
      mod_atm(max_ppO2).to_fsw - GasBlender::ATM.new(1.0).to_fsw
    end

    def mod_msw(max_ppO2)
      mod_atm(max_ppO2).to_msw - GasBlender::ATM.new(1.0).to_msw
    end

    private

    alias :fO2_want :mix

    def fO2_have
      Mix.new(tank.current_mix)
    end

    def fO2_need
      Mix.new(ppO2_need / pressure_need)
    end

    def ppO2_want
      tank.service_pressure * fO2_want
    end

    def ppO2_have
      tank.current_pressure * fO2_have
    end

    def ppO2_need
      ppO2_want - ppO2_have
    end

    def pressure_want
      tank.service_pressure
    end

    def pressure_have
      tank.current_pressure
    end

    def pressure_need
      pressure_want - pressure_have
    end

    def mod_atm(max_ppO2)
      GasBlender::ATM.new((max_ppO2.to_bar / mix) / Bar.new(1.0))
    end
  end
end