require 'gosu'

require_relative 'shared'
require_relative 'state_base'
require_relative 'main_menu_state'
require_relative 'top_scores_parser'


class TopScoresState < StateBase

	def initialize(window)
		super window

		@font_large = Gosu::Font.new(@window, Gosu::default_font_name, 80)
		@font_small = Gosu::Font.new(@window, Gosu::default_font_name, 20)

		@top_scores = TopScoresParser.load
	end

	def draw	
		@font_large.draw_rel("TOP SCORES", 
			@window.width / 2, Shared::START_Y, 0, #x, y, z
			0.5, 0.5, #rel_x, rel_y
			1.0, 1.0, Shared::COLOR)

		@top_scores.each_with_index do |(k,v), i|
			@font_small.draw_rel("#{i + 1}. #{k}: #{v}", 
			@window.width / 2, Shared::START_Y + @font_large.height + (@font_small.height  * i) , 0, #x, y, z
			0.5, 0.5, #rel_x, rel_y
			1.0, 1.0, Shared::COLOR)			
		end

			@font_small.draw_rel('Esc to return', 
			@window.width / 2, Shared::START_Y + @font_large.height + (@font_small.height  * (@top_scores.size + 1)) , 0, #x, y, z
			0.5, 0.5, #rel_x, rel_y
			1.0, 1.0, Shared::COLOR)		


	end

	def button_down(id)
		if id == Gosu::KbEscape
			@window.set_state(MainMenuState.new(@window))
		end
	end
	

end