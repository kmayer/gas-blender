require "gas-blender"

module GasBlender
  describe "Top-off scenarios" do
    it "given an empty tank, fill to 200 bar with EAN32" do
      tank = Tank.new(
        service_pressure: Bar.new(200)
      )
      fill = Fill.new(
        mix:  0.32,
        tank: tank
      )
      expect(fill.pressure).to be_within(Bar.new(0.05)).of(Bar.new(27.8))
    end

    it "given an empty tank, fill to 3000 psi with EAN36" do
      tank = Tank.new(
        service_pressure: PSI.new(3000)
      )
      fill = Fill.new(
        mix:  0.36,
        tank: tank
      )
      expect(fill.pressure).to be_within(PSI.new(0.5)).of(PSI.new(569.6))
    end

    it "given a tank with 1467 psi of EAN29, fill to 200 bar of EAN 36" do
      tank = Tank.new(
        service_pressure: Bar.new(200),
        current_pressure: Bar.new(67),
        current_mix:      0.32
      )
      fill = Fill.new(
        mix:  0.36,
        tank: tank
      )
      expect(fill.pressure).to be_within(Bar.new(0.05)).of(tank.current_pressure + Bar.new(28.6))
    end

    it "given a tank with 1000 psi of EAN28, fill to 3000 psi of EAN36 with EAN50" do
      tank = Tank.new(
        service_pressure: PSI.new(3000),
        current_pressure: PSI.new(1000),
        current_mix:      0.28
      )
      fill = Fill.new(
        mix:      0.36,
        tank:     tank,
        fill_mix: 0.50
      )
      expect(fill.pressure).to be_within(PSI.new(0.5)).of(tank.current_pressure + PSI.new(1310))
    end

    it "given an empty tank, fill to 232 bar of EAN36 with EAN100, top off with EAN32" do
      tank = Tank.new(
        service_pressure: Bar.new(232)
      )
      fill = Fill.new(
        mix:         0.36,
        tank:        tank,
        top_off_mix: 0.32
      )
      expect(fill.pressure).to be_within(Bar.new(0.05)).of(tank.current_pressure + Bar.new(13.6))
    end

    it "given a tank with 220 bar of EAN36, bleed to 161.3 and fill with air" do
      tank = Tank.new(
        service_pressure: Bar.new(220),
        current_pressure: Bar.new(220),
        current_mix:      0.36
      )
      fill = Fill.new(mix: 0.32, tank: tank)
      expect(fill.pressure).to be_within(Bar.new(0.05)).of(tank.current_pressure - Bar.new(58.7))
    end
  end
end