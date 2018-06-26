module Socratic
	class Question < ApplicationRecord
		belongs_to 		:survey

		has_many 		:prompts
		has_many 		:responses
	end
end
