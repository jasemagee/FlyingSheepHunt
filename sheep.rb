require 'gosu'

class Sheep 
	def initialize(window)
		@image = Gosu::Image.new(window, "assets/sheep.png", false)
		reload
	end

	def reload
		@direction = rand(2)

		if @direction == 1
			@x = -@image.width
		else
			@direction = -1
			@x = 640 + @image.width
		end

		@y = rand * (480 - @image.height)
	end

	def update(delta)
		if @direction == 1
			if @x >= 640
				reload
			end
		else
			if @x <= -@image.width
				reload	
			end
		end

		@x += @direction * 200 * delta


	end

	def draw  
		@image.draw(@x, @y, 1)
	end

end
