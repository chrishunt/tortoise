Tortoise [![Build Status](https://secure.travis-ci.org/huntca/tortoise.png)](http://travis-ci.org/huntca/tortoise)
========
[logo]: http://en.wikipedia.org/wiki/Logo_(programming_language) "Logo Programming Language"
[rubygems]: https://rubygems.org/ "Rubygems"

Tortoise is a [Logo][logo] interpreter for Ruby. To demonstrate the
awesomeness of Logo, we'll draw a ruby! This example can be found in the
repository at `spec/data/simple.logo`.

    > Tortoise::Interpreter.new <<-LOGO
        61
        RT 135
        FD 5
        REPEAT 2 [ RT 90 FD 15 ]
        RT 90
        FD 5
        RT 45
        FD 20
      LOGO

      . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . .
      . . . . . . X X X X X X X X X X X X X X X X X X X X X . . . . . .
      . . . . . X . . . . . . . . . . . . . . . . . . . . . X . . . . .
      . . . . X . . . . . . . . . . . . . . . . . . . . . . . X . . . .
      . . . X . . . . . . . . . . . . . . . . . . . . . . . . . X . . .
      . . X . . . . . . . . . . . . . . . . . . . . . . . . . . . X . .
      . X . . . . . . . . . . . . . . . . . . . . . . . . . . . . . X .
      . . X . . . . . . . . . . . . . . . . . . . . . . . . . . . X . .
      . . . X . . . . . . . . . . . . . . . . . . . . . . . . . X . . .
      . . . . X . . . . . . . . . . . . . . . . . . . . . . . X . . . .
      . . . . . X . . . . . . . . . . . . . . . . . . . . . X . . . . .
      . . . . . . X . . . . . . . . . . . . . . . . . . . X . . . . . .
      . . . . . . . X . . . . . . . . . . . . . . . . . X . . . . . . .
      . . . . . . . . X . . . . . . . . . . . . . . . X . . . . . . . .
      . . . . . . . . . X . . . . . . . . . . . . . X . . . . . . . . .
      . . . . . . . . . . X . . . . . . . . . . . X . . . . . . . . . .
      . . . . . . . . . . . X . . . . . . . . . X . . . . . . . . . . .
      . . . . . . . . . . . . X . . . . . . . X . . . . . . . . . . . .
      . . . . . . . . . . . . . X . . . . . X . . . . . . . . . . . . .
      . . . . . . . . . . . . . . X . . . X . . . . . . . . . . . . . .
      . . . . . . . . . . . . . . . X . X . . . . . . . . . . . . . . .
      . . . . . . . . . . . . . . . . X . . . . . . . . . . . . . . . .
      . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . .

Installation
------------
Tortoise is available on [rubygems.org][rubygems]. To install, add
`gem tortoise` to your `Gemfile` or install manually with:

    gem install tortoise

Usage
-----
To use Tortoise, create an instance of `Tortoise::Interpreter` and execute
any of the supported Logo commands.

    # specify canvas size for this drawing
    canvas_size = 11
    interpreter = Tortoise::Interpreter.new(canvas_size)

    # execute any supported commands
    interpreter.rt(90)
    interpreter.fd(3)
    interpreter.lt(45)
    interpreter.bk(4)

Tortoise also accepts commands as an input string:

    interpreter = Tortoise::Interpreter.new(11)
    interpreter.draw "RT 90"
    interpreter.draw "FD 3"
    interpreter.draw "LT 45"
    interpreter.draw "BK 4"

You can execute entire blocks of commands at once:

    interpreter = Tortoise::Interpreter.new(61)

    interpreter.draw <<-STEPS
      RT 135
      FD 5
      REPEAT 2 [ RT 90 FD 15 ]
      RT 90
      FD 5
      RT 45
      FD 20
    STEPS

Finally, commands can be executed when a `Tortoise::Interpreter` is
instantiated. The command string must contain the canvas size in the
first line. This is most useful when reading commands from a file.
Assume we have the file `drawing.logo`:

    61
    RT 135
    FD 5
    REPEAT 2 [ RT 90 FD 15 ]
    RT 90
    FD 5
    RT 45
    FD 20

We can load and execute `drawing.logo` with:

    file = File.new('drawing.logo')
    tortoise = Tortoise::Interpreter.new(file.read)

Command Line Usage
------------------
Tortoise can be used on the command line to render logo command files. The
output is rendered to standard out.

    Usage: tortoise [OPTIONS] [FILE]

    Options:
      --ascii   Render ascii output (default)
      --html    Render html output
      --png     Render png output

For example, if you'd like to render `drawing.logo` to `drawing.txt` as ascii:

    $ tortoise drawing.logo > drawing.txt

Or as html:

    $ tortoise --html drawing.logo > drawing.html

Or as png:

    $ tortoise --png drawing.logo > drawing.png

Rendering The Canvas
--------------------
Tortoise can currently render its canvas as ascii or as html.

    interpreter = Tortoise::Interpreter.new(5)

    interpreter.to_ascii  #=> return ascii
    interpreter.to_html   #=> return html
    interpreter.to_png    #=> return a png blob

Supported Commands
------------------
Tortoise only supports a small subset of all [Logo][logo] commands.

- `RT x`: Turn the tortoise `x` degrees to the right (increments of 45)
- `LT x`: Turn the tortoise `x` degrees to the right (increments of 45)
- `FD x`: Move the tortoise `x` steps forward
- `BK x`: Move the tortoise `x` steps backward
- `REPEAT n [ x ]`: Repeat commands `x` a total of `n` times
