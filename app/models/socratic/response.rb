module Socratic
	class Surveying < ApplicationRecord
		belongs_to	 	:surveying
		belongs_to		:question
		belongs_to		:prompt
	end
end
