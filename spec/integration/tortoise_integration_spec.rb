require 'tortoise'

describe Tortoise::Interpreter do
  before do
    input  = File.new('./spec/data/simple.logo').read
    @interpreter = Tortoise::Interpreter.new(input)
  end

  it 'produces the expected ascii output' do
    ascii = File.new('./spec/data/simple.ascii').read
    @interpreter.to_ascii.should == ascii
  end

  it 'produces the expected html output' do
    html = File.new('./spec/data/simple.html').read
    @interpreter.to_html.should == html
  end
end
