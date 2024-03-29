require "gas-blender"

module GasBlender
  describe Fill do
    describe "top off pressure" do
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
          mix:  32.ean,
          tank: tank
        )
        expect(fill.pressure).to be_within(0.05.bar).of(tank.current_pressure - 58.7.bar)
      end

      # Some more examples from the workbook
      it "given a tank with 720 psi of 31.3, fill to 3000 psi of EAN31" do
        tank = Tank.new(
          service_pressure: 3000.psi,
          current_pressure: 720.psi,
          current_mix:      Mix.new(0.313)
        )
        fill = Fill.new(
          mix:  31.ean,
          tank: tank
        )
        expect(fill.pressure).to be_within(1.psi).of(1005.psi)
      end

      it "given an empty tank, fill to 3000 psi with EAN31" do
        tank = Tank.new(service_pressure: 3000.psi)
        fill = Fill.new(mix: 31.ean, tank: tank)
        expect(fill.pressure).to be_within(1.psi).of(380.psi)
      end

      it "given a tank with 190 psi of 31.7%, fill to 3000 psi of EAN31" do
        tank = Tank.new(
          service_pressure: 3000.psi,
          current_pressure: 190.psi,
          current_mix:      Mix.new(0.317)
        )
        fill = Fill.new(
          mix:  31.ean,
          tank: tank
        )
        expect(fill.pressure).to be_within(1.psi).of(544.psi)
      end
    end

    describe "maximum operating depth" do
      # http://en.wikipedia.org/wiki/Maximum_operating_depth
      context "Imperial" do
        let(:tank) { Tank.new(service_pressure: 3000.psi)}

        it "given EAN36 and max ppO2 of 1.4" do
          fill = Fill.new(mix: 36.ean, tank: tank)
          expect(fill.mod(1.4.bar)).to be_within(0.1.feet).of(95.3.feet)
        end

        it "EAN3 and max ppO2 of 1.6" do
          fill = Fill.new(mix: 3.ean)
          expect(fill.mod_fsw(1.6.bar)).to be_within(1.feet).of(1727.feet)
        end

        it "EAN100 and max ppO2 of 1.2" do
          fill = Fill.new(mix: 100.ean)
          expect(fill.mod_fsw(1.2.bar)).to be_within(1.feet).of(6.feet)
        end
      end

      context "Metric" do
        let(:tank) { Tank.new(service_pressure: 200.bar)}

        it "given EAN36 and ppO2 of 1.4" do
          fill = Fill.new(mix: 36.ean, tank: tank)
          expect(fill.mod(1.4.bar)).to be_within(0.1.meters).of(28.9.meters)
        end

        it "EAN3 and max ppO2 of 1.2" do
          fill = Fill.new(mix: 3.ean)
          expect(fill.mod_msw(1.2.bar)).to be_within(0.1.meters).of(390.0.meters)
        end

        it "EAN100 and max ppO2 of 1.6" do
          fill = Fill.new(mix: 100.ean)
          expect(fill.mod_msw(1.6.bar)).to be_within(0.1.meters).of(6.0.meters)
        end
      end
    end
  end
end
