require 'gosu'

class Player
  def initialize(window)
    @image = Gosu::Image.new(window, "assets/crosshair.png", false)
    @x = @y = 0.0
    @move_speed = 5
    @half_width = (@image.width / 2)
    @half_height = (@image.height / 2)
  end

  def warp(x, y)
    @x, @y = x, y
  end

  def move(mouse_x, mouse_y)
    @x = mouse_x - @half_width
    @y = mouse_y - @half_height

    @x = 0 if @x < 0
    @y = 0 if @y < 0
       
    @x = (640 - @image.width) if @x > (640 - @image.width)
    @y = (480 - @image.height) if @y > (480 - @image.height)
  end

  def fullscreen?()
    true
  end

  def draw
    @image.draw(@x, @y, 1)
  end
end