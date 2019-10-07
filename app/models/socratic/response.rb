module Socratic
	class Response < ApplicationRecord
		belongs_to 		:user, optional: true
		belongs_to	 	:surveying
		belongs_to		:question
		belongs_to		:prompt, optional: true

		before_update :set_content_from_prompt



		private
			def set_content_from_prompt
				self.content = self.prompt.content if ( self.prompt.present? && self.content.blank? )
				#self.content = self.prompt.title if ( self.prompt.present? && self.content.blank? )
			end
	end
end
