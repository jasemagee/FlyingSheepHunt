require 'gosu'
require_relative 'player'
require_relative 'sheep'

class GameWindow < Gosu::Window

	def initialize
		super 640, 480, false, 5 # 200FPS
		self.caption = "Flying Sheep Hunt"

		@last_update = Gosu::milliseconds
		@elapsed_time = 0

		@background_image = Gosu::Image.new(self, 'assets/background.png', false)
		@player = Player.new(self)
		@sheep = Array.new
	end

	def update	
		calculate_elapsed_time

		if rand(100) < 4 and @sheep.size < 25 then
			@sheep.push(Sheep.new(self))
		end

		@player.update(mouse_x, mouse_y)
		@sheep.each { |s| s.update(@elapsed_time) }
	end

	def calculate_elapsed_time
		this_update = Gosu::milliseconds
		@elapsed_time = (this_update - @last_update) / 1000.0
		@last_update = this_update
	end

	def draw
		@background_image.draw(0,0,0)
		@sheep.each {|s| s.draw }
		@player.draw
	end

	def button_down(id)
		if id == Gosu::KbEscape
			close
		end
	end


end

window = GameWindow.new
window.show