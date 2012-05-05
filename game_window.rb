require 'gosu'
require_relative 'player'
require_relative 'sheep'

class GameWindow < Gosu::Window

	WINDOW_WIDTH = 640
	WINDOW_HEIGHT = 480
	MAX_SHEEP_COUNT = 25

	attr_accessor :sheep

	def initialize
		super WINDOW_WIDTH, WINDOW_HEIGHT, false 
		#Increasing the update_interval doesn't improve frame rate??

		self.caption = "Flying Sheep Hunt"

		@last_update = Gosu::milliseconds
		@delta = 0

		@background_image = Gosu::Image.new(self, 'assets/background.png', false)
		
		@player = Player.new(self)

		# We keep the sheep image and bloot splat here, so we only load them into memory once
		# and pass them into the sheep instances
		@sheep_image = Gosu::Image.new(self, "assets/sheep.png", false)
		@blood_splat_image = Gosu::Image.new(self, "assets/blood_splat.png", false)
		@sheep = Array.new

		(1..MAX_SHEEP_COUNT).each { @sheep.push(Sheep.new(self, @sheep_image, @blood_splat_image)) }

		@score = 0
		@lives = 10
	end

	def update	
		calculate_delta

		if rand(100) < 4
			match  = @sheep.detect { |s| !s.spawned }

			if match
				match.spawn
			end
		end



		@player.update(mouse_x, mouse_y)
		@sheep.each { |s| s.update(@delta) }
	end


	def calculate_delta
		this_update = Gosu::milliseconds
		@delta = (this_update - @last_update) / 1000.0
		@last_update = this_update
	end

	def draw
		#puts Gosu::fps

		@background_image.draw(0,0,0)
		@sheep.each {|s| s.draw }
		@player.draw
	end

	def button_down(id)
		if id == Gosu::KbEscape
			close
		end

		if id == Gosu::MsLeft
			@player.fire
		end
	end


end

window = GameWindow.new
window.show