require 'gosu'

require_relative 'shared'
require_relative 'state_base'
require_relative 'gameplay_state'
require_relative 'top_scores_state'
require_relative 'menu_item'

class MainMenuState < StateBase

	TITLE_SIZE = 55
	NORMAL_SIZE = 20
	SELECTED_SIZE = 40

	def initialize(window)
		super window

		@title_font = Gosu::Font.new(@window, Gosu::default_font_name, 55)
		@normal_font = Gosu::Font.new(@window, Gosu::default_font_name, 24)
		@selected_font = Gosu::Font.new(@window, Gosu::default_font_name, 36)

		@menu_items = Array.new
		@menu_items.push(MenuItem.new(@window, "Start") { @window.set_state(GameplayState.new(@window)) })
		@menu_items.push(MenuItem.new(@window, "Best Scores") { @window.set_state(TopScoresState.new(@window)) })
		@menu_items.push(MenuItem.new(@window, "Exit") { @window.close })

		@window.cursor = true

		@selected_index = nil
	end

	def update_selected_index
		@menu_items.each_index do |i|
			font = i == @selected_index ? @selected_font : @normal_font

			if @menu_items[i].mouse_over?(font, @window.mouse_x, @window.mouse_y) 
				@selected_index = i
				return
			end
		end
	end

	def update(delta)
		update_selected_index

		@menu_items.each_index do |i|
			font = i == @selected_index ? @selected_font : @normal_font

			menu_item_width = @menu_items[i].get_width(font)
			x = (@window.width / 2) - (menu_item_width / 2)
			y = Shared::START_Y + (i * @menu_items[i].get_height(@selected_font))

			@menu_items[i].x = x
			@menu_items[i].y = y
		end
	end

	def draw
		@title_font.draw_rel("Flying Sheep Hunt", 
			@window.width / 2, 0, 0, #x, y, z
			0.5, 0, #rel_x, rel_y
			1.0, 1.0, Shared::COLOR)
		
		@menu_items.each_index do |i| 
			@menu_items[i].draw(i == @selected_index ? @selected_font : @normal_font) 
		end
	end

	def button_down(id)
		if id == Gosu::KbEscape
			@window.close
		end
		if id == Gosu::MsLeft
			clicked = @menu_items.detect { |item| item.mouse_over?(@normal_font, @window.mouse_x, @window.mouse_y) }

			if clicked
				clicked.on_clicked
			end
		end
	end
end