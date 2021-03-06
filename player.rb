require 'gosu'

require_relative 'gameplay_z_order'

class Player

  def initialize(state)
    @state = state
    @image = Gosu::Image.new(@state.window, "assets/crosshair.png", false)
    @rifle_sound = Gosu::Sample.new(@state.window, "assets/rifle.wav")
    @x = @y = 0.0
    @move_speed = 5
    @half_width = (@image.width / 2)
    @half_height = (@image.height / 2)
  end

  def fire
    @rifle_sound.play
    sheep_shot = @state.sheep.detect { |s| s.is_shot?(@x, @y) }

    if sheep_shot
      sheep_shot.kill
    end
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
    @image.draw(@x, @y, GameplayZOrder::Player)
  end

end