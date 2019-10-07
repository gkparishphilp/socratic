module Socratic
	class Page < SwellMedia::Page
		belongs_to	 	:survey

		has_many 		:questions
	end
end
