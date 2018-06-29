module Socratic
	class Survey < ApplicationRecord
		has_many 		:questions
		has_many 		:surveyings
	end
end
