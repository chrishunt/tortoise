require 'chunky_png'

module Tortoise
  class Presenter
    attr_reader :canvas

    PIXEL_SIZE = 5

    def initialize(interpreter)
      @canvas = interpreter.canvas
    end

    def to_ascii
      oriented_canvas.inject('') do |ascii, column|
        column.each do |pixel|
          char = pixel ? 'X' : '.'
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

    def to_png
      white = ChunkyPNG::Color('white')
      black = ChunkyPNG::Color('black')
      png   = ChunkyPNG::Image.new(@canvas.size, @canvas.size)

      @canvas.each_with_index do |column, x|
        column.reverse.each_with_index do |pixel, y|
          png[x, y] = pixel ? black : white
        end
      end

      png.to_blob
    end

    private

    def new_canvas
      Array.new(@canvas.size) { Array.new(@canvas.size) {false} }
    end

    def oriented_canvas
      oriented = new_canvas
      @canvas.each_with_index do |column, i|
        column.each_with_index do |pixel, j|
          oriented[@canvas.size-1-j][i] = pixel
        end
      end
      oriented
    end

    def html_head
      <<-HTML
        <head>
        <title>Tortoise</title>
        <style type="text/css">
          * { margin: 0; padding: 0; }

          body { background: #555; }

          .column { float: left; }

          .empty { background: #ddd; }

          .filled { background: #111; }

          #canvas {
            overflow: hidden;
            border: #{PIXEL_SIZE}px solid #111;
            width: #{@canvas.size * PIXEL_SIZE}px;
            margin: 50px auto 10px auto; }

          .pixel {
            width: #{PIXEL_SIZE}px;
            height: #{PIXEL_SIZE}px; }
        </style>
        </head>
      HTML
    end

    def html_canvas
      @canvas.inject("<div id='canvas'>") do |html, column|
        html += "<div class='column'>"
        column.reverse.each do |pixel|
          pixel_class = pixel ? 'filled' : 'empty'
          html += "<div class='pixel #{pixel_class}'></div>"
        end
        html += "</div>"
      end + "</div>"
    end
  end
end
