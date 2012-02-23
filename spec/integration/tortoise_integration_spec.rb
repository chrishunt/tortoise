require 'tortoise'

describe Tortoise::Interpreter do
  it 'produces the expected ascii output' do
    input  = File.new('./spec/data/simple.logo').read
    output = File.new('./spec/data/simple_out.ascii').read

    Tortoise::Interpreter.new(input).to_ascii.should == output
  end
end
