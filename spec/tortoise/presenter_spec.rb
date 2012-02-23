require 'tortoise/presenter.rb'

describe Tortoise::Presenter do
  it 'saves the interpreter canvas' do
    interpreter = stub(:size => stub, :canvas => stub)
    presenter = Tortoise::Presenter.new(interpreter)
    presenter.canvas.should == interpreter.canvas
  end

  describe 'rendering engines' do
    before do
      interpreter = Tortoise::Interpreter.new <<-STEPS
        5
        RT 90
        FD 1
        REPEAT 2 [ RT 45 ]
        FD 2
        REPEAT 2 [ LT 45 ]
        FD 1
        RT 180
        FD 2
      STEPS
      @presenter = Tortoise::Presenter.new(interpreter)
    end

    describe '#to_ascii' do
      it 'renders ascii representation of canvas' do
        @presenter.to_ascii.should == "" +
          ". . . . .\n" +
          ". . . . .\n" +
          ". . X X .\n" +
          ". . . X .\n" +
          ". . X X X\n"
      end
    end

    describe '#to_html' do
      it 'renders html representation of canvas' do
        html = @presenter.to_html
        html.scan('html').size.should == 3
        html.scan('body').size.should == 3
        html.scan('canvas').size.should == 2
        html.scan('column').size.should == 6
        html.scan('pixel').size.should == 26
      end
    end
  end
end
