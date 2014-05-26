require "gas-blender/pressure"

module GasBlender
  describe Pressure do
    subject(:pressure) { Pressure.new(1) }

    it "is immutable" do
      expect(pressure).to be_frozen
    end
  end

  describe Bar do
    subject(:pressure) { Bar.new(1) }

    it "has a nice string representation" do
      expect(pressure.to_s).to eq("1.0 bar")
    end

    it "is equal by value" do
      expect(pressure).to eq(Bar.new(1))
    end

    it "is not rude by comparison" do
      expect(pressure).to_not eq("fish")
    end

    it "will implicitly convert, however" do
      expect(pressure).to eq(PSI.new(14.5038))
    end

    it "converts to bar" do
      expect(pressure.to_bar).to eq(Bar.new(1))
    end

    it "converts to psi" do
      expect(pressure.to_psi).to eq(PSI.new(14.5038))
    end
  end

  describe PSI do
    subject(:pressure) { PSI.new(1) }

    it "has a nice string representation" do
      expect(pressure.to_s).to eq("1.0 psi")
    end

    it "is equal by value" do
      expect(pressure).to eq(PSI.new(1))
    end

    it "is not rude by comparison" do
      expect(pressure).to_not eq("fish")
    end

    it "will implicitly convert, however" do
      expect(pressure).to eq(Bar.new(0.0689474))
    end

    it "converts to bar" do
      expect(pressure.to_bar).to eq(Bar.new(0.0689474))
    end

    it "converts to psi" do
      expect(pressure.to_psi).to eq(PSI.new(1))
    end
  end
end
