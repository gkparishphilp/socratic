module Socratic
	class Page < ApplicationRecord
		belongs_to	 	:survey

		has_many 		:questions
	end
end
