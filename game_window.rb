require 'gosu'
require_relative 'main_menu_state'
require_relative 'gameplay_state'

class GameWindow < Gosu::Window

	WINDOW_WIDTH = 640
	WINDOW_HEIGHT = 480

	attr_accessor :cursor
	
	def initialize
		super WINDOW_WIDTH, WINDOW_HEIGHT, false 
		# Changing the update_interval doesn't improve frame rate?? 
		# I can lower the frame rate, but not increase

		self.cursor = false

		self.caption = "Flying Sheep Hunt"

		@last_update = Gosu::milliseconds
		@delta = 0

		set_state(MainMenuState.new(self))
	end

	def needs_cursor?
		@cursor
	end

	def set_state(new_state)
		@current_state = new_state
	end

	def update	
		calculate_delta
		@current_state.update(@delta)
	end

	def calculate_delta
		this_update = Gosu::milliseconds
		@delta = (this_update - @last_update) / 1000.0
		@last_update = this_update
	end

	def draw
		#puts Gosu::fps
		@current_state.draw
	end

	def button_down(id)
		@current_state.button_down(id)
	end

end

window = GameWindow.new
window.show