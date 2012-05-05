require 'gosu'
require_relative 'player'
require_relative 'sheep'
require_relative 'state_base'

class GameplayState < StateBase

	SHEEP_INCREMENT = 2
	MAX_LEVEL = 15
	SCORE_PER_KILL = 100
	SECONDS_PER_LEVEL = 10

	attr_accessor :sheep
	attr_reader :window, :time_playing


	def initialize(window)
		super window

		@window.cursor = false
		
		@background_image = Gosu::Image.new(@window, 'assets/background.png', false)
		
		@player = Player.new(self)

		# We keep the sheep image and bloot splat here, so we only load them into memory once
		# and pass them into the sheep instances
		@sheep_image = Gosu::Image.new(@window, "assets/sheep.png", false)
		@blood_splat_image = Gosu::Image.new(@window, "assets/blood_splat.png", false)
		@sheep = Array.new

		max_sheep_count = MAX_LEVEL * SHEEP_INCREMENT

		(1..max_sheep_count).each { @sheep.push(Sheep.new(self, @sheep_image, @blood_splat_image)) }

		@time_playing = 0.0
		@score = 0
		@lives = 10

		@current_level_index = 1
	end

	def update(delta) 
		@time_playing += delta

		if @time_playing >= (SECONDS_PER_LEVEL * @current_level_index)
			@current_level_index += 1
			puts "Level Increased to #{@current_level_index}"
		end

		alive_sheep = @sheep.select { |s| s.alive }

		if alive_sheep.size < (@current_level_index * SHEEP_INCREMENT)
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

	def sheep_killed
		@score += SCORE_PER_KILL * @current_level_index

		puts "Score #{@score}"
	end

	def sheep_escaped
		@lives -= 1

		puts "Lives: #{@lives}"

		if @lives <= 0
			# game over
		end
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
