require 'gosu'

class Sheep 

	SPEED = 100

	attr_accessor :escaped, :alive, :spawned

	def initialize(window, sheep_image, blood_splat_image)
		@window = window	
		@sheep_image = sheep_image 
		@blood_splat_image = blood_splat_image		
		@x = @y = @direction = 0
		@alive = @escaped = @spawned = false
	end

	def is_shot?(x, y)
		if @alive && !@escaped
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
		@alive = false
	end

	def escape
		@escaped = true
	end

	def spawn
		@spawned = @alive = true
		@escaped = false

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
		if @alive
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
	end

	TOP_COLOR = Gosu::Color.new(0xFF1EB1FA)

	def draw

		#if @dir == :left then
		#	offs_x = -25
		#	factor = 1.0
		#else
		#	offs_x = 25
		#	factor = -1.0
		#end
		#@cur_image.draw(@x + offs_x, @y - 49, 0, factor, 1.0)

		if @spawned && !@escaped
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
