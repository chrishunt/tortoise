def filled_pixels(canvas)
  canvas.inject(0) do |count, column|
    count += column.inject(0) { |count, pixel| count += pixel ? 1 : 0 }
  end
end
