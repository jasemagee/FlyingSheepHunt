require 'gosu'

class Player


  def initialize(window, state)
    @state = state
    @image = Gosu::Image.new(window, "assets/crosshair.png", false)
    @x = @y = 0.0
    @move_speed = 5
    @half_width = (@image.width / 2)
    @half_height = (@image.height / 2)
  end

  def fire
    sheep_shot = @state.sheep.detect { |s| s.is_shot?(@x, @y) }

    if sheep_shot
      sheep_shot.kill
    end
    # If enough time passed since last shot
    # Play fire sound
    # Reset last fire time
    # Loop over sheep, finding any that are hit
    # If hit, call sheep kill
  end

  def update(mouse_x, mouse_y)
    @x = mouse_x - @half_width
    @y = mouse_y - @half_height

    @x = 0 if @x < 0
    @y = 0 if @y < 0
       
    @x = (640 - @image.width) if @x > (640 - @image.width)
    @y = (480 - @image.height) if @y > (480 - @image.height)
  end

  def draw
    @image.draw(@x, @y, 3)
  end

end