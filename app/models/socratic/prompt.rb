module Socratic
	class Prompt < ApplicationRecord
		belongs_to	 	:question
	end
end
