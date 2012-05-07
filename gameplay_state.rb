require 'gosu'
require_relative 'player'
require_relative 'sheep'
require_relative 'state_base'
require_relative 'gameplay_z_order'
require_relative 'gameover_state'

class GameplayState < StateBase

	SHEEP_INCREMENT = 2
	MAX_LEVEL = 15
	SCORE_PER_KILL = 100
	SECONDS_PER_LEVEL = 10
	GUI_COLOR = 0xff000000

	attr_accessor :sheep
	attr_reader :window, :time_playing


	def initialize(window)
		super window

		@window.cursor = false
		@paused = false
		
		@background_image = Gosu::Image.new(@window, 'assets/background.png', false)
		
		@player = Player.new(self)

		# We keep the sheep image and bloot splat here, so we only load them into memory once
		# and pass them into the sheep instances
		@sheep_image = Gosu::Image.new(@window, "assets/sheep.png", false)
		@blood_splat_image = Gosu::Image.new(@window, "assets/blood_splat.png", false)
		@sheep = Array.new

		max_sheep_count = MAX_LEVEL * SHEEP_INCREMENT

		(1..max_sheep_count).each { @sheep.push(Sheep.new(self, @sheep_image, @blood_splat_image)) }

		@gui_font = Gosu::Font.new(@window, Gosu::default_font_name, 16)

		@time_playing = 0.0
		@score = 0
		@lives = 10

		@current_level_index = 1
	end

	def update(delta) 
		# It seems more 'normal' to be able to use the cursor when paused
		@player.update(@window.mouse_x, @window.mouse_y)

		if !@paused
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

			@sheep.each { |s| s.update(delta) }
		end
	end

	def draw 		
		@background_image.draw(0, 0, GameplayZOrder::Background)
		@sheep.each {|s| s.draw }
		@player.draw

		# Draw lives
		@gui_font.draw_rel("Lives: #{@lives}", 
			@window.width, @window.height, GameplayZOrder::Gui, #x, y, z
			1, 1, #rel_x, rel_y
			1.0, 1.0, GUI_COLOR)

		# Draw score
		@gui_font.draw_rel("Score: #{@score}", 
			0, @window.height, GameplayZOrder::Gui, #x, y, z
			0, 1, #rel_x, rel_y
			1.0, 1.0, GUI_COLOR)

		if @paused
			@gui_font.draw_rel('Paused', 
			@window.width / 2, @window.height / 2, GameplayZOrder::Gui, #x, y, z
			0.5, 0.5, #rel_x, rel_y
			1.0, 1.0, GUI_COLOR)
		end
	end

	def sheep_killed
		@score += SCORE_PER_KILL * @current_level_index
	end

	def sheep_escaped
		@lives -= 1
		if @lives <= 0
			@window.set_state(GameoverState.new(@window, @score))
		end
	end

	def button_down(id)
		if id == Gosu::KbEscape
			@window.close
		end

			if id == Gosu::MsLeft			
				@player.fire unless @paused
			end

			if id == Gosu::KbP
				@paused = !@paused
			end
		
	end

end

