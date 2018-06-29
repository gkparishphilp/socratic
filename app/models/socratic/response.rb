module Socratic
	class Response < ApplicationRecord
		belongs_to 		:user
		belongs_to	 	:surveying
		belongs_to		:question
		belongs_to		:prompt
	end
end
