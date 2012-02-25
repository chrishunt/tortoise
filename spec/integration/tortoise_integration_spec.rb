require 'tortoise'

describe Tortoise::Interpreter do
  context 'when rendering the ruby' do
    before do
      input  = File.new('./spec/data/ruby.logo').read
      @interpreter = Tortoise::Interpreter.new(input)
    end

    it 'produces the expected ascii output' do
      ascii = File.new('./spec/data/ruby.ascii').read
      @interpreter.to_ascii.should == ascii
    end

    it 'produces the expected html output' do
      html = File.new('./spec/data/ruby.html').read
      @interpreter.to_html.should == html
    end
  end

  context 'when rendering the smiley face' do
    before do
      input  = File.new('./spec/data/smile.logo').read
      @interpreter = Tortoise::Interpreter.new(input)
    end

    it 'produces the expected ascii output' do
      ascii = File.new('./spec/data/smile.ascii').read
      @interpreter.to_ascii.should == ascii
    end
  end
end
