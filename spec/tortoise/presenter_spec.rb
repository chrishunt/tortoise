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
      it 'renders a ascii representation of the canvas' do
        @presenter.to_ascii.should == "" +
          ". . . . .\n" +
          ". . . . .\n" +
          ". . X X .\n" +
          ". . . X .\n" +
          ". . X X X\n"
      end
    end

    describe '#to_html' do
      it 'renders a html representation of the canvas' do
        html = @presenter.to_html
        html.scan('html').size.should == 3
        html.scan('body').size.should == 3
        html.scan('canvas').size.should == 2
        html.scan('column').size.should == 6
        html.scan('pixel').size.should == 26
      end
    end

    describe '#to_png' do
      before do
        blob = @presenter.to_png
        @png = ChunkyPNG::Image.from_blob(blob)
      end

      it 'renders png with the correct dimensions' do
        @png.width.should == 5
        @png.height.should == 5
      end

      it 'renders png with the correct image data' do
        w = ChunkyPNG::Color('white')
        b = ChunkyPNG::Color('black')

        @png.should == ChunkyPNG::Image.new(5, 5, [
          w, w, w, w, w,
          w, w, w, w, w,
          w, w, b, b, w,
          w, w, w, b, w,
          w, w, b, b, b ])
      end
    end
  end
end
