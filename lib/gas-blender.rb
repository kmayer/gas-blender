require_relative "gas-blender/version"
require_relative "gas-blender/pressure"
require_relative "gas-blender/tank"
require_relative "gas-blender/fill"

module GasBlender
  module_function

  def Pressure(arg)
    case arg
    when Bar, PSI
      arg
    when String
      string_conversion(arg)
    else
      raise TypeError, "Can not convert #{arg.inspect} to Pressure"
    end
  end

  private

  def self.string_conversion(arg)
    case
    when arg =~ /(\d.*) bar/
      Bar.new($1.to_f)
    when arg =~ /(\d.*) psi/
      PSI.new($1.to_f)
    else
      raise TypeError, "Can not convert #{arg.inspect} to Pressure"
    end
  end
end

class Fixnum
  def bar
    GasBlender::Bar.new(self)
  end
  def psi
    GasBlender::PSI.new(self)
  end
end

class Float
  def bar
    GasBlender::Bar.new(self)
  end
  def psi
    GasBlender::PSI.new(self)
  end
end