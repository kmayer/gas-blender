require "gas-blender"

module GasBlender
  describe Mix do
    subject(:mix) { Mix.new(0.32) }
    it "is immutable" do
      expect(mix).to be_frozen
    end

    it "can convert to a float" do
      expect(mix.to_f).to eq(0.32)
    end

    it "implements Comparable" do
      expect(Mix.new(0.36) <=> Mix.new(0.28)).to eq(1)
      expect(Mix.new(0.28) <=> Mix.new(0.28)).to eq(0)
      expect(Mix.new(0.28) <=> Mix.new(0.36)).to eq(-1)
    end
  end
end
