require 'tortoise/interpreter'
require 'helpers/interpreter_helper'

describe Tortoise::Interpreter do
  let(:tortoise) { Tortoise::Interpreter.new(11) }

  it 'can be initialized with a canvas size' do
    tortoise = Tortoise::Interpreter.new(11)
    tortoise.size.should == 11
  end

  it 'can be initialized with instructions' do
    instructions = <<-STEPS
      5
      REPEAT 2 [ RT 45 ]
      FD 1
    STEPS
    tortoise = Tortoise::Interpreter.new(instructions)
    tortoise.size.should == 5
    tortoise.direction.should == 90
    tortoise.position.should == [3, 2]
  end

  it 'starts with no marked pixels on the canvas' do
    filled_pixels(tortoise.canvas).should == 0
  end

  it 'defaults tortoise position to the center of the canvas' do
    tortoise.position.should == [5, 5]
  end

  it 'defaults tortoise direction to zero degrees (up)' do
    tortoise.direction.should == 0
  end

  it 'defaults with the tortoise pen up' do
    tortoise.pen_down?.should == false
  end

  describe '#draw' do
    it 'draws the image on the canvas when given a string' do
      tortoise = Tortoise::Interpreter.new(5)
      tortoise.draw <<-STEPS
        PD
        RT 90
        FD 1
        REPEAT 2 [ RT 45 ]
        FD 2
        REPEAT 2 [ LT 45 ]
        FD 1
        RT 180
        FD 2
      STEPS
      tortoise.canvas.should == [
        [false, false, false, false, false],
        [false, false, false, false, false],
        [true , false, true , false, false],
        [true , true , true , false, false],
        [true , false, false, false, false]]
    end

    it 'draws the image on the canvas when given an array' do
      tortoise = Tortoise::Interpreter.new(5)
      tortoise.draw([
        'PD',
        'RT 90',
        'FD 1',
        'REPEAT 2 [ RT 45 ]',
        'FD 2',
        'REPEAT 2 [ LT 45 ]',
        'FD 1',
        'RT 180',
        'FD 2'])
      tortoise.canvas.should == [
        [false, false, false, false, false],
        [false, false, false, false, false],
        [true , false, true , false, false],
        [true , true , true , false, false],
        [true , false, false, false, false]]
    end
  end

  describe '#setpos' do
    it 'moves the tortoise to the specified position' do
      tortoise.position.should == [5, 5]
      tortoise.setpos(2, 4)
      tortoise.position.should == [2, 4]
    end

    it 'fills in landing spot when pen is down' do
      filled_pixels(tortoise.canvas).should == 0
      tortoise.pd
      tortoise.setpos(0, 0)
      filled_pixels(tortoise.canvas).should == 2
    end

    it 'does not fill in landing spot when pen is up' do
      filled_pixels(tortoise.canvas).should == 0
      tortoise.pu
      tortoise.setpos(0, 0)
      filled_pixels(tortoise.canvas).should == 0
    end

    it 'does not set a position outside the canvas' do
      tortoise.setpos(100, 100)
      tortoise.position.should == [10, 10]
    end
  end

  describe '#pu' do
    it 'lifts the pen from the canvas' do
      tortoise.pd
      tortoise.pen_down?.should == true
      tortoise.pu
      tortoise.pen_down?.should == false
    end
  end

  describe '#pd' do
    it 'places the pen onto the canvas' do
      tortoise.pu
      tortoise.pen_down?.should == false
      tortoise.pd
      tortoise.pen_down?.should == true
    end

    it 'fills in a pixel when the pen hits the canvas' do
      filled_pixels(tortoise.canvas).should == 0
      tortoise.pu
      tortoise.fd(2)
      tortoise.pd
      filled_pixels(tortoise.canvas).should == 1
    end
  end

  describe '#rt' do
    it 'can rotate the tortoise 45 degrees to the right' do
      tortoise.rt(45)
      tortoise.direction.should == 45
    end

    it 'can rotate the tortoise 360 degrees to the right' do
      tortoise.rt(360)
      tortoise.direction.should == 0
    end

    it 'can rotate the tortoise 495 degrees to the right' do
      tortoise.rt(495)
      tortoise.direction.should == 135
    end

    it 'can rotate the tortoise 810 degrees to the right' do
      tortoise.rt(810)
      tortoise.direction.should == 90
    end

    it 'can rotate the tortoise multiple times' do
      tortoise.rt(90)
      tortoise.rt(45)
      tortoise.direction.should == 135
    end
  end

  describe '#lt' do
    it 'can rotate the tortoise 45 degrees to the left' do
      tortoise.lt(45)
      tortoise.direction.should == 315
    end

    it 'can rotate the tortoise 360 degrees to the left' do
      tortoise.lt(360)
      tortoise.direction.should == 0
    end

    it 'can rotate the tortoise 495 degrees to the left' do
      tortoise.lt(495)
      tortoise.direction.should == 225
    end

    it 'can rotate the tortoise 810 degrees to the left' do
      tortoise.lt(810)
      tortoise.direction.should == 270
    end

    it 'can rotate the tortoise multiple times' do
      tortoise.lt(90)
      tortoise.lt(45)
      tortoise.direction.should == 225
    end
  end

  describe '#rotate' do
    it 'can rotate the tortoise 45 degrees' do
      tortoise.send(:rotate, 45)
      tortoise.direction.should == 45
    end

    it 'can rotate the tortoise 90 degrees' do
      tortoise.send(:rotate, 90)
      tortoise.direction.should == 90
    end

    it 'can rotate the tortoise 360 degrees' do
      tortoise.send(:rotate, 360)
      tortoise.direction.should == 0
    end

    it 'can rotate the tortoise 495 degrees' do
      tortoise.send(:rotate, 495)
      tortoise.direction.should == 135
    end

    it 'can rotate the tortoise 810 degrees' do
      tortoise.send(:rotate, 810)
      tortoise.direction.should == 90
    end

    it 'can rotate the tortoise -45 degrees' do
      tortoise.send(:rotate, -45)
      tortoise.direction.should == 315
    end

    it 'can rotate the tortoise -90 degrees' do
      tortoise.send(:rotate, -90)
      tortoise.direction.should == 270
    end

    it 'can rotate the tortoise -360 degrees' do
      tortoise.send(:rotate, -360)
      tortoise.direction.should == 0
    end

    it 'can rotate the tortoise -495 degrees' do
      tortoise.send(:rotate, -495)
      tortoise.direction.should == 225
    end

    it 'can rotate the tortoise -810 degrees' do
      tortoise.send(:rotate, -810)
      tortoise.direction.should == 270
    end

    it 'can rotate the tortoise multiple times' do
      tortoise.send(:rotate, 90)
      tortoise.send(:rotate, 45)
      tortoise.direction.should == 135
    end
  end

  describe '#fd' do
    it 'moves the tortoise forward when facing 0 degress' do
      x, y = tortoise.position
      tortoise.fd(2)
      tortoise.position.should == [x, y + 2]
    end

    it 'moves the tortoise forward when facing 45 degress' do
      x, y = tortoise.position
      tortoise.rt(45)
      tortoise.fd(2)
      tortoise.position.should == [x + 2, y + 2]
    end

    it 'moves the tortoise forward when facing 90 degress' do
      x, y = tortoise.position
      tortoise.rt(90)
      tortoise.fd(2)
      tortoise.position.should == [x + 2, y]
    end

    it 'moves the tortoise forward when facing 135 degress' do
      x, y = tortoise.position
      tortoise.rt(135)
      tortoise.fd(2)
      tortoise.position.should == [x + 2, y - 2]
    end

    it 'moves the tortoise forward when facing 180 degress' do
      x, y = tortoise.position
      tortoise.rt(180)
      tortoise.fd(2)
      tortoise.position.should == [x, y - 2]
    end

    it 'moves the tortoise forward when facing 225 degress' do
      x, y = tortoise.position
      tortoise.rt(225)
      tortoise.fd(2)
      tortoise.position.should == [x - 2, y - 2]
    end

    it 'moves the tortoise forward when facing 270 degress' do
      x, y = tortoise.position
      tortoise.rt(270)
      tortoise.fd(2)
      tortoise.position.should == [x - 2, y]
    end

    it 'moves the tortoise forward when facing 315 degress' do
      x, y = tortoise.position
      tortoise.rt(315)
      tortoise.fd(2)
      tortoise.position.should == [x - 2, y + 2]
    end

    it 'stops when it reaches the top of the canvas' do
      tortoise.fd(100)
      x, y = tortoise.position
      y.should < tortoise.size
    end

    it 'stops when it reaches the bottom of the canvas' do
      tortoise.rt(180)
      tortoise.fd(100)
      x, y = tortoise.position
      y.should >= 0
    end

    it 'stops when it reaches the right of the canvas' do
      tortoise.rt(90)
      tortoise.fd(100)
      x, y = tortoise.position
      x.should < tortoise.size
    end

    it 'stops when it reaches the left of the canvas' do
      tortoise.rt(270)
      tortoise.fd(100)
      x, y = tortoise.position
      x.should >= 0
    end

    it 'draws on traveled areas of the canvas when pen is down' do
      tortoise = Tortoise::Interpreter.new(5)
      tortoise.pd
      tortoise.rt(90)
      tortoise.fd(1)
      tortoise.rt(90)
      tortoise.fd(2)
      tortoise.lt(90)
      tortoise.fd(1)
      tortoise.rt(180)
      tortoise.fd(2)
      tortoise.canvas.should == [
        [false, false, false, false, false],
        [false, false, false, false, false],
        [true , false, true , false, false],
        [true , true , true , false, false],
        [true , false, false, false, false]]
    end

    it 'does not draw on traveled areas of the canvas when pen is up' do
      tortoise = Tortoise::Interpreter.new(5)
      tortoise.stub(:pen_down? => false)
      tortoise.fd(2)
      filled_pixels(tortoise.canvas).should == 0
    end
  end

  describe '#bk' do
    it 'moves the tortoise forward when facing 0 degress' do
      x, y = tortoise.position
      tortoise.bk(2)
      tortoise.position.should == [x, y - 2]
    end

    it 'moves the tortoise forward when facing 45 degress' do
      x, y = tortoise.position
      tortoise.rt(45)
      tortoise.bk(2)
      tortoise.position.should == [x - 2, y - 2]
    end

    it 'moves the tortoise forward when facing 90 degress' do
      x, y = tortoise.position
      tortoise.rt(90)
      tortoise.bk(2)
      tortoise.position.should == [x - 2, y]
    end

    it 'moves the tortoise forward when facing 135 degress' do
      x, y = tortoise.position
      tortoise.rt(135)
      tortoise.bk(2)
      tortoise.position.should == [x - 2, y + 2]
    end

    it 'moves the tortoise forward when facing 180 degress' do
      x, y = tortoise.position
      tortoise.rt(180)
      tortoise.bk(2)
      tortoise.position.should == [x, y + 2]
    end

    it 'moves the tortoise forward when facing 225 degress' do
      x, y = tortoise.position
      tortoise.rt(225)
      tortoise.bk(2)
      tortoise.position.should == [x + 2, y + 2]
    end

    it 'moves the tortoise forward when facing 270 degress' do
      x, y = tortoise.position
      tortoise.rt(270)
      tortoise.bk(2)
      tortoise.position.should == [x + 2, y]
    end

    it 'moves the tortoise forward when facing 315 degress' do
      x, y = tortoise.position
      tortoise.rt(315)
      tortoise.bk(2)
      tortoise.position.should == [x + 2, y - 2]
    end

    it 'stops when it reaches the bottom of the canvas' do
      tortoise.bk(100)
      x, y = tortoise.position
      y.should >= 0
    end

    it 'stops when it reaches the top of the canvas' do
      tortoise.rt(180)
      tortoise.bk(100)
      x, y = tortoise.position
      y.should < tortoise.size
    end

    it 'stops when it reaches the left of the canvas' do
      tortoise.rt(90)
      tortoise.bk(100)
      x, y = tortoise.position
      x.should >= 0
    end

    it 'stops when it reaches the right of the canvas' do
      tortoise.rt(270)
      tortoise.bk(100)
      x, y = tortoise.position
      x.should < tortoise.size
    end

    it 'draws on traveled areas of the canvas when pen is down' do
      tortoise = Tortoise::Interpreter.new(5)
      tortoise.pd
      tortoise.lt(90)
      tortoise.bk(1)
      tortoise.rt(90)
      tortoise.bk(2)
      tortoise.lt(90)
      tortoise.bk(1)
      tortoise.rt(180)
      tortoise.bk(2)
      tortoise.canvas.should == [
        [false, false, false, false, false],
        [false, false, false, false, false],
        [true , false, true , false, false],
        [true , true , true , false, false],
        [true , false, false, false, false]]
    end

    it 'does not draw on traveled areas of the canvas when pen is up' do
      tortoise = Tortoise::Interpreter.new(5)
      tortoise.stub(:pen_down? => false)
      tortoise.bk(2)
      filled_pixels(tortoise.canvas).should == 0
    end
  end

  describe '#execute' do
    it 'can execute lowercase commands' do
      tortoise.send(:execute, 'rt 90')
      tortoise.direction.should == 90
    end

    it 'can execute putting the pen down' do
      tortoise.pu
      tortoise.pen_down?.should == false
      tortoise.send(:execute, 'PD')
      tortoise.pen_down?.should == true
    end

    it 'can execute lifting the pen up' do
      tortoise.pd
      tortoise.pen_down?.should == true
      tortoise.send(:execute, 'PU')
      tortoise.pen_down?.should == false
    end

    it 'can execute setpos commands' do
      tortoise.position.should == [5, 5]
      tortoise.send(:execute, 'SETPOS 2 4')
      tortoise.position.should == [2, 4]
    end

    it 'can execute right turns' do
      tortoise.send(:execute, 'RT 90')
      tortoise.direction.should == 90
    end

    it 'can execute left turns' do
      tortoise.send(:execute, 'LT 90')
      tortoise.direction.should == 270
    end

    it 'can execute forward steps' do
      x, y = tortoise.position
      tortoise.send(:execute, 'FD 3')
      tortoise.position.should == [x, y + 3]
    end

    it 'can execute backward steps' do
      x, y = tortoise.position
      tortoise.send(:execute, 'BK 2')
      tortoise.position.should == [x, y - 2]
    end

    it 'can execute single item repeat blocks' do
      tortoise.send(:execute, 'REPEAT 2 [ RT 45 ]')
      tortoise.direction.should == 90
    end

    it 'can execute multi-item repeat blocks' do
      tortoise.send(:execute, 'REPEAT 2 [ PD RT 45 SETPOS 0 0 LT 90 ]')
      tortoise.direction.should == 270
      tortoise.position.should == [0, 0]
    end

    it 'can execute commands with extra whitespace' do
      tortoise.send(:execute, ' RT 90 ')
      tortoise.direction.should == 90
    end

    it 'does not raise error with blank lines' do
      command = lambda { tortoise.send(:execute, '  ') }
      command.should_not raise_error
    end

    it 'does not raise error with zero params in repeat command' do
      command = lambda { tortoise.send(:execute, 'REPEAT 2 [ RT 0 PD ]') }
      command.should_not raise_error
    end

    it 'raises error with unknown commands' do
      command = lambda { tortoise.send(:execute, 'UNKNOWN') }
      command.should raise_error
    end
  end

  %w(ascii html png).each do |format|
    describe "#to_#{format}" do
      it 'delegates rendering to presenter' do
        presenter = stub('presenter')
        Tortoise::Presenter.stub(:new => presenter)
        interpreter = Tortoise::Interpreter.new(5)

        presenter.should_receive("to_#{format}")
        interpreter.send("to_#{format}")
      end
    end
  end
end
