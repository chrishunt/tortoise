module Tortoise
  class Interpreter
    attr_reader :size, :position, :direction, :canvas

    def initialize(instructions)
      lines = instructions.to_s.split("\n")

      @size = lines.shift.to_i
      @canvas = {}
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

    def to_ascii
      (@size - 1).downto(0).inject('') do |ascii, y|
        0.upto(@size - 1).each do |x|
          pixel = "x#{x}y#{y}".to_sym
          char = canvas[pixel] ? 'X' : '.'
          ascii += "#{char} "
        end
        ascii = ascii.strip + "\n"
      end
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
      pixel = "x#{x}y#{y}".to_sym
      @canvas[pixel] = true
    end

    def place_in_canvas_bounds(x, y)
      x = 0 if x < 0
      y = 0 if y < 0
      x = @size - 1 if x >= @size
      y = @size - 1 if y >= @size
      [x, y]
    end

    def html_head
      pixel_size = 8
      <<-HTML
        <head>
        <title>Tortoise</title>
        <style type="text/css">
          * { margin: 0; padding: 0; }

          body { background: #555; }

          #canvas {
            overflow: hidden;
            border: #{pixel_size}px solid #000;
            width: #{@size * pixel_size}px;
            margin: 50px auto 10px auto;
          }

          .column { float: left; }

          .pixel {
            width: #{pixel_size}px;
            height: #{pixel_size}px;
          }

          .empty { background: #ddd; }

          .filled { background: #111; }
        </style>
        </head>
      HTML
    end

    def html_canvas
      0.upto(@size - 1).inject("<div id='canvas'>") do |html, x|
        html += "<div class='column'>"
        (@size - 1).downto(0).each do |y|
          pixel = "x#{x}y#{y}".to_sym
          pixel_class = canvas[pixel] ? 'filled' : 'empty'
          html += "<div class='pixel #{pixel_class}'></div>"
        end
        html += "</div>"
      end + "</div>"
    end
  end
end
