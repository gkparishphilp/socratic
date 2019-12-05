module Socratic
	class Response < ApplicationRecord
		belongs_to 		:user, optional: true
		belongs_to	 	:surveying
		belongs_to		:question
		belongs_to		:prompt, optional: true

		before_save :set_content_from_prompt



		private
			def set_content_from_prompt
				if self.prompt.present?
					self.content = self.prompt.title
					self.content ||= self.prompt.content
				end
			end
	end
end
