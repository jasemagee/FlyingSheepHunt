require 'yaml'

module TopScoresParser

	TOP_SCORES_FILENAME = 'top_scores.yaml'

	def self.load
		full_path = File.join(Dir.getwd, TOP_SCORES_FILENAME)

		if (File.exists?(full_path))
			top_scores = YAML.load_file(full_path)
			# If the file is wrong or empty, it won't be a Hash
			top_scores = Hash.new unless top_scores.class == Hash
		else
			File.open(full_path, 'w') {} 
			top_scores = Hash.new
		end

		top_scores = Hash[top_scores.sort_by {|k,v| v }.reverse]
	end

	def self.add_if_fits_in_top_scores(name, score)
		top_scores = load
		top_scores[name] = score
		top_scores = Hash[top_scores.sort_by {|k,v| v }.reverse]
		top_scores = Hash[top_scores.take(5)]
		File.open(File.join(Dir.getwd, TOP_SCORES_FILENAME), 'w') do |out|
			YAML.dump(top_scores, out )
		end
	end
end