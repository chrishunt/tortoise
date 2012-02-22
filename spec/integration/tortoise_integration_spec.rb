require 'tortoise'

describe Tortoise::Interpreter do
  it 'produces the expected string output' do
    input  = File.new('./spec/data/simple.logo').read
    output = File.new('./spec/data/simple_out.txt').read

    Tortoise::Interpreter.new(input).to_s.should == output
  end
end
