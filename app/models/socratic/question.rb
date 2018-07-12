module Socratic
	class Question < ApplicationRecord
		belongs_to 		:survey

		has_many 		:prompts, dependent: :destroy
		has_many 		:responses, dependent: :destroy
	end
end
