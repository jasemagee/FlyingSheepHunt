require 'gosu'

require_relative 'state_base'
require_relative 'main_menu_state'

class GameoverState < StateBase

	COLOR = 0xff000000
	START_Y = 160

	def initialize(window, score)
		super window

		@score = score

		@font_large = Gosu::Font.new(@window, Gosu::default_font_name, 80)
		@font_small = Gosu::Font.new(@window, Gosu::default_font_name, 20)
	end

	def draw
		@font_large.draw_rel("GAME OVER", 
			@window.width / 2, START_Y, 0, #x, y, z
			0.5, 0.5, #rel_x, rel_y
			1.0, 1.0, COLOR)

		@font_large.draw_rel("SCORE #{@score}", 
			@window.width / 2, (START_Y) + @font_large.height, 0, #x, y, z
			0.5, 0.5, #rel_x, rel_y
			1.0, 1.0, COLOR)

		@font_small.draw_rel("Press Esc", 
			@window.width / 2, (START_Y) + (@font_large.height * 2), 0, #x, y, z
			0.5, 0.5, #rel_x, rel_y
			1.0, 1.0, COLOR)
	end

	def button_down(id)
		if id == Gosu::KbEscape
			@window.set_state(MainMenuState.new(@window))
		end
	end
	

end