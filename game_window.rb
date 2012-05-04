require 'gosu'
require_relative 'player'

class GameWindow < Gosu::Window

	def initialize
		super 640, 480, false
		self.caption = "Sheep Hunt"

		@background_image = Gosu::Image.new(self, 'assets/background.png', false)

		@player = Player.new(self)
		@player.warp(320, 240)
	end

	def update
		@player.move(mouse_x, mouse_y)
	end

	def draw
		@player.draw
		@background_image.draw(0,0,0)

	end

	def button_down(id)
		if id == Gosu::KbEscape
			close
		end
	end


end

window = GameWindow.new
window.show