module Tortoise
  class Interpreter
    attr_reader :size, :position, :direction, :canvas

    def initialize(instructions)
      lines = instructions.to_s.split("\n")

      @size = lines.shift.to_i
      @canvas = new_canvas
      @direction = 0
      center = (@size - @size/2) - 1

      update_position(center, center)
      draw(lines)
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

    def to_s
      s = ''
      oriented_canvas.each do |column|
        column.each do |pixel|
          char = pixel ? 'X' : '.'
          s += "#{char} "
        end
        s = s.strip + "\n"
      end
      s
    end

    def to_html
      <<-HTML
        <!DOCTYPE html>
        <html>
        #{html_head}
        <body>
          #{html_canvas}
        </body>
        </html>
      HTML
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
      words = command.split(' ')
      if words.size == 2
        method, param = words
        self.send(method.downcase, param.to_i)
      else
        1.upto(words[1].to_i) do
          commands = words[3..words.size-2]
          execute(commands.shift(2).join(' ')) while commands.size > 0
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

    def oriented_canvas
      oriented = new_canvas
      @canvas.each_with_index do |column, i|
        column.each_with_index do |pixel, j|
          oriented[@size-1-j][i] = pixel
        end
      end
      oriented
    end

    def html_head
      pixel_size = 1
      <<-HTML
        <head>
        <title>Tortoise</title>
        <style type="text/css">
          * { margin: 0; padding: 0; }

          body { background: #eee; }

          #canvas {
            overflow: hidden;
            border: 1px solid #000;
            width: #{@size * pixel_size}px;
            margin: 50px auto 10px auto;
          }

          .column {
            float: left;
          }

          .pixel {
            width: #{pixel_size}px;
            height: #{pixel_size}px;
          }

          .empty {
            background: #ccc;
          }

          .filled {
            background: #111;
          }
        </style>
        </head>
      HTML
    end

    def html_canvas
      html = "<div id='canvas'>"
      @canvas.each do |column|
        html += "<div class='column'>"
        column.reverse.each do |pixel|
          pixel_class = pixel ? 'filled' : 'empty'
          html += "<div class='pixel #{pixel_class}'></div>"
        end
        html += "</div>"
      end
      html += "</div>"
    end
  end
end
