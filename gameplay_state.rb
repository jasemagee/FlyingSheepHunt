require 'gosu'
require_relative 'player'
require_relative 'sheep'
require_relative 'state_base'

class GameplayState < StateBase

	MAX_SHEEP_COUNT = 25

	attr_accessor :sheep

	def initialize(window)
		super window

		@window.cursor = false
		@background_image = Gosu::Image.new(@window, 'assets/background.png', false)
		
		@player = Player.new(@window, self)

		# We keep the sheep image and bloot splat here, so we only load them into memory once
		# and pass them into the sheep instances
		@sheep_image = Gosu::Image.new(@window, "assets/sheep.png", false)
		@blood_splat_image = Gosu::Image.new(@window, "assets/blood_splat.png", false)
		@sheep = Array.new

		(1..MAX_SHEEP_COUNT).each { @sheep.push(Sheep.new(@window, @sheep_image, @blood_splat_image)) }

		@score = 0
		@lives = 10
	end

	def update(delta) 
		if rand(100) < 4
			match  = @sheep.detect { |s| !s.spawned }

			if match
				match.spawn
			end
		end

		@player.update(@window.mouse_x, @window.mouse_y)
		@sheep.each { |s| s.update(delta) }
	end

	def draw 		
		@background_image.draw(0,0,0)
		@sheep.each {|s| s.draw }
		@player.draw
	end

	def button_down(id)
		if id == Gosu::KbEscape
			@window.close
		end

		if id == Gosu::MsLeft
			@player.fire
		end
	end

end

