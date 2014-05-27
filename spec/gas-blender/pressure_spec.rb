require "gas-blender"

module GasBlender
  describe Pressure do
    subject(:pressure) { Pressure.new(1) }

    it "is immutable" do
      expect(pressure).to be_frozen
    end

    it "is hashes by magnitude and class" do
      expect(Pressure.new(1).hash).to eq(Pressure.new(1).hash)
      expect(Pressure.new(1).hash).not_to eq(Bar.new(1).hash)
    end
  end

  describe Bar do
    subject(:pressure) { Bar.new(1) }

    it "has a nice string representation" do
      expect(pressure.to_s).to eq("1.00000000 bar")
    end

    it "is equal by value" do
      expect(pressure).to eq(Bar.new(1))
    end

    it "equal values have eql? hashes" do
      expect(Bar.new(1)).to be_eql(Bar.new(1))
    end

    it "is not rude by comparison" do
      expect(pressure).to_not eq("fish")
    end

    it "will implicitly convert, however" do
      expect(pressure).to eq(PSI.new(14.5037738))
    end

    it "implements Comparable" do
      expect(Bar.new(9) <=> Bar.new(5)).to eq(1)
      expect(Bar.new(5) <=> Bar.new(5)).to eq(0)
      expect(Bar.new(5) <=> Bar.new(9)).to eq(-1)
    end

    it "converts to bar" do
      expect(pressure.to_bar).to eq(Bar.new(1))
    end

    it "converts to psi" do
      expect(pressure.to_psi).to eq(PSI.new(14.5037738))
    end
  end

  describe PSI do
    subject(:pressure) { PSI.new(1) }

    it "has a nice string representation" do
      expect(pressure.to_s).to eq("1.00000000 psi")
    end

    it "is equal by value" do
      expect(pressure).to eq(PSI.new(1))
    end

    it "equal values have eql? hashes" do
      expect(PSI.new(1)).to be_eql(PSI.new(1))
    end

    it "is not rude by comparison" do
      expect(pressure).to_not eq("fish")
    end

    it "will implicitly convert, however" do
      expect(pressure).to eq(Bar.new(0.0689475729))
    end

    it "converts to bar" do
      expect(pressure.to_bar).to eq(Bar.new(0.0689475729))
    end

    it "converts to psi" do
      expect(pressure.to_psi).to eq(PSI.new(1))
    end
  end

  describe "Conversion function" do
    it "is idempotent" do
      expect(GasBlender::Pressure(Bar.new(1))).to eq(Bar.new(1))
      expect(GasBlender::Pressure(PSI.new(1))).to eq(PSI.new(1))
    end

    it "parses strings" do
      expect(GasBlender::Pressure("1 bar")).to eq(Bar.new(1))
      expect(GasBlender::Pressure("1 psi")).to eq(PSI.new(1))
    end

    it "raises a helpful error" do
      expect {
        GasBlender::Pressure(1.0)
      }.to raise_error(TypeError)
    end

    it "EAN" do
      expect(32.ean).to eq(Mix.new(0.32))
    end
  end
end
