require "gas-blender"

module GasBlender
  describe "Top-off scenarios" do
    it "given an empty tank, fill to 200 bar with EAN32" do
      tank = Tank.new(
        service_pressure: 200.bar
      )
      fill = Fill.new(
        mix:  32.ean,
        tank: tank
      )
      expect(fill.pressure).to be_within(0.05.bar).of(27.8.bar)
    end

    it "given an empty tank, fill to 3000 psi with EAN36" do
      tank = Tank.new(
        service_pressure: 3000.psi
      )
      fill = Fill.new(
        mix:  36.ean,
        tank: tank
      )
      expect(fill.pressure).to be_within(0.05.psi).of(569.6.psi)
    end

    it "given a tank with 1467 psi of EAN29, fill to 200 bar of EAN 36" do
      tank = Tank.new(
        service_pressure: 200.bar,
        current_pressure: 67.bar,
        current_mix:      32.ean
      )
      fill = Fill.new(
        mix:  36.ean,
        tank: tank
      )
      expect(fill.pressure).to be_within(0.05.bar).of(tank.current_pressure + 28.6.bar)
    end

    it "given a tank with 1000 psi of EAN28, fill to 3000 psi of EAN36 with EAN50" do
      tank = Tank.new(
        service_pressure: 3000.psi,
        current_pressure: 1000.psi,
        current_mix:      28.ean
      )
      fill = Fill.new(
        mix:      36.ean,
        tank:     tank,
        fill_mix: 50.ean
      )
      expect(fill.pressure).to be_within(0.5.psi).of(tank.current_pressure + 1310.psi)
    end

    it "given an empty tank, fill to 232 bar of EAN36 with EAN100, top off with EAN32" do
      tank = Tank.new(
        service_pressure: 232.bar
      )
      fill = Fill.new(
        mix:         36.ean,
        tank:        tank,
        top_off_mix: 32.ean
      )
      expect(fill.pressure).to be_within(0.05.bar).of(tank.current_pressure + 13.6.bar)
    end

    it "given a tank with 220 bar of EAN36, bleed to 161.3 and fill with air" do
      tank = Tank.new(
        service_pressure: 220.bar,
        current_pressure: 220.bar,
        current_mix:      36.ean
      )
      fill = Fill.new(
        mix: 32.ean,
        tank: tank
      )
      expect(fill.pressure).to be_within(0.05.bar).of(tank.current_pressure - 58.7.bar)
    end
  end
end