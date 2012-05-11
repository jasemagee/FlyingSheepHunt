require 'gosu'

require_relative 'state_base'
require_relative 'main_menu_state'
require_relative 'top_scores_parser'

class GameoverState < StateBase

	def initialize(window, score)
		super window

		@score = score

		@font_large = Gosu::Font.new(@window, Gosu::default_font_name, 80)
		@font_small = Gosu::Font.new(@window, Gosu::default_font_name, 20)

		
		@text_inputter =  Gosu::TextInput.new
		@window.text_input = @text_inputter
	end

	def draw
		@font_large.draw_rel("GAME OVER", 
			@window.width / 2, Shared::START_Y, 0, #x, y, z
			0.5, 0.5, #rel_x, rel_y
			1.0, 1.0, Shared::COLOR)

		@font_large.draw_rel("SCORE #{@score}", 
			@window.width / 2, (Shared::START_Y) + @font_large.height, 0, #x, y, z
			0.5, 0.5, #rel_x, rel_y
			1.0, 1.0, Shared::COLOR)

		@font_small.draw_rel("NAME:", 
			@window.width / 2, (Shared::START_Y) + (@font_large.height * 2), 0, #x, y, z
			0.5, 0.5, #rel_x, rel_y
			1.0, 1.0, Shared::COLOR)

		@font_small.draw_rel("#{@text_inputter.text}", 
			@window.width / 2, (Shared::START_Y) + (@font_large.height * 2) + (@font_small.height), 0, #x, y, z
			0.5, 0.5, #rel_x, rel_y
			1.0, 1.0, Shared::COLOR)

		@font_small.draw_rel("Press Enter", 
			@window.width / 2, (Shared::START_Y) + (@font_large.height * 2) + (@font_small.height * 2), 0, #x, y, z
			0.5, 0.5, #rel_x, rel_y
			1.0, 1.0, Shared::COLOR)
end

def button_down(id)
	if id == Gosu::KbEnter || id == Gosu::KbReturn
		TopScoresParser.add_if_fits_in_top_scores(@text_inputter.text, @score)
		@window.text_input = nil
		@window.set_state(MainMenuState.new(@window))
	end
end


end