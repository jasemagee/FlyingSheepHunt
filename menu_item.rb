require 'gosu'

require_relative 'shared'
require_relative 'main_menu_state'

class MenuItem

	attr_accessor :x, :y

	def initialize(window, text, &action)
		@window = window
		@text = text
		@action = action

		self.x = self.y = 0
	end

	def draw(font)
		font.draw(@text, self.x, self.y, 0, 1, 1, Shared::COLOR)
	end

	def mouse_over?(font, mouse_x, mouse_y)
		if mouse_x >= self.x && mouse_y <= (self.x + get_width(font)) &&
			mouse_y >= self.y && mouse_y <= (self.y + get_height(font))
			true
		else
			false
		end
	end

	def on_clicked
		@action.call(@window)
	end

	def get_width(font)
		font.text_width(@text, 1)
	end

	def get_height(font)
		font.height
	end
end