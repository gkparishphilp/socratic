module Socratic
	class Prompt < ApplicationRecord
		belongs_to	 	:question

		before_save :set_content_from_title



		def set_content_from_title
			self.content ||= self.title
		end
	end
end
