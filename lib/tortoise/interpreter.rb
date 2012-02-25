module Tortoise
  class Interpreter
    attr_reader :size, :position, :direction, :canvas

    def initialize(instructions)
      lines = instructions.to_s.split("\n")

      @size = lines.shift.to_i
      @canvas = new_canvas
      @direction = 0
      @pen_down = true
      center = (@size - @size/2) - 1

      update_position(center, center)
      draw(lines)
    end

    def setpos(x, y)
      @position = place_in_canvas_bounds(x, y)
    end

    def pu
      @pen_down = false
    end

    def pd
      @pen_down = true
    end

    def pen_down?
      @pen_down
    end

    def rt(degrees)
      rotate(degrees)
    end

    def lt(degrees)
      rotate(-degrees)
    end

    def fd(steps)
      walk(steps)
    end

    def bk(steps)
      walk(-steps)
    end

    def draw(commands)
      commands = commands.split("\n") if commands.respond_to?(:split)
      commands.each { |command| execute(command) }
    end

    %w(ascii html png).each do |format|
      define_method("to_#{format}") do
        Tortoise::Presenter.new(self).send("to_#{format}")
      end
    end

    private

    def new_canvas
      Array.new(@size) { Array.new(@size) {false} }
    end

    def update_position(x, y)
      @position = place_in_canvas_bounds(x, y)
      update_canvas
    end

    def rotate(degrees)
      @direction += degrees
      @direction += 360 while @direction < 0
      @direction -= 360 while @direction >= 360
    end

    def execute(command)
      commands = command.split(' ')
      return if commands.empty?

      command = commands.shift.downcase
      if command == 'repeat'
        count = commands.shift.to_i
        commands = commands[1..commands.size-2]
        repeat(commands, count)
      else
        params = commands.map(&:to_i)
        self.send(command, *params)
      end
    end

    def repeat(commands, count)
      count.times do
        c = commands.dup
        while c.size > 0
          command = c.shift
          params = []
          params << c.shift while c[0].to_s.match(/[0-9]/)
          execute("#{command} #{params.join(' ')}")
        end
      end
    end

    def walk(steps)
      x, y  = @position
      step  = steps < 0 ? -1 : 1
      steps = steps < 0 ? -steps : steps

      1.upto(steps) do
        x, y = case direction
          when 0;   [x,        y + step]
          when 45;  [x + step, y + step]
          when 90;  [x + step, y       ]
          when 135; [x + step, y - step]
          when 180; [x,        y - step]
          when 225; [x - step, y - step]
          when 270; [x - step, y       ]
          when 315; [x - step, y + step]
        end
        update_position(x, y)
      end
    end

    def update_canvas
      return unless pen_down?
      x, y = @position
      @canvas[x][y] = true
    end

    def place_in_canvas_bounds(x, y)
      x = 0 if x < 0
      y = 0 if y < 0
      x = @size - 1 if x >= @size
      y = @size - 1 if y >= @size
      [x, y]
    end
  end
end
