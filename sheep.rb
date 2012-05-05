require 'gosu'

class Sheep 

	SPEED = 100

	attr_accessor :alive, :spawned

	def initialize(state, sheep_image, blood_splat_image)
		@state = state	
		@sheep_image = sheep_image 
		@blood_splat_image = blood_splat_image		
		@x = @y = @direction = @time_of_death = 0
		@alive = @spawned = false
	end

	def is_shot?(x, y)
		if @alive
			if x >= @x && x <= (@x + @sheep_image.width) &&
				y >= @y && y <= (@y + @sheep_image.height)
				true
			else
				false
			end
		else
			false
		end
	end

	def kill
		@state.sheep_killed
		@alive = false
		@time_of_death = @state.time_playing
	end

	def escape
		@state.sheep_escaped
		@spawned = false
	end

	def spawn
		@spawned = @alive = true

		@direction = rand(2)

		if @direction == 1
			@x = -@sheep_image.width
		else
			@direction = -1
			@x = 640 + @sheep_image.width
		end

		@y = rand * (480 - @sheep_image.height)
	end

	def update(delta)
		if @alive && @spawned
			if @direction == 1
				if @x >= 640
					escape
				end
			else
				if @x <= -@sheep_image.width
					escape	
				end
			end

			@x += @direction * SPEED * delta
		end

		if !@alive && @spawned
			if @state.time_playing >= @time_of_death + 3
				@time_of_death = 0
				@spawned = false
			end
		end
	end

	TOP_COLOR = Gosu::Color.new(0xFF1EB1FA)

	def draw
		if @spawned
			if @alive
				if @direction == 1
					factor = -1
					x_offset = @sheep_image.width
				else
					factor = 1
					x_offset = 0
				end
				@sheep_image.draw(@x + x_offset, @y, 2, factor)

				#@window.draw_quad(
				#	@x, @y, TOP_COLOR, # Top Left
				#	@x + @sheep_image.width, @y, TOP_COLOR, # Top Right
				#	@x, @y + @sheep_image.height, TOP_COLOR, # Bottom Left
				#	@x + @sheep_image.width, @y + @sheep_image.height, TOP_COLOR, # Bottom Right
				#	1)
			else
				@blood_splat_image.draw(@x, @y, 2)
			end
		end
	end

end
