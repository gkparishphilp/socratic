module Socratic
	class Surveying < ApplicationRecord
		belongs_to	 	:survey 
		belongs_to		:user
	end
end
