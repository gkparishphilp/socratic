module Socratic
	class Survey < ApplicationRecord
		has_many 		:questions
	end
end
