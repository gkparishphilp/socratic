module Socratic
	class Question < ApplicationRecord
		belongs_to 		:survey
		belongs_to 		:page, optional: true

		has_many 		:prompts, dependent: :destroy
		has_many 		:responses, dependent: :destroy

		before_validation	:set_seq, :set_title

		validates	:title, presence: true

		include FriendlyId
		friendly_id :title, use: [ :slugged ]


		def self.uis
			[ ['Text Box', 'text_box' ], [ 'Text Area', 'text_area'], ['Radio Buttons', 'radio'], ['Check Boxes', 'check_box' ], ['Select', 'select' ] ]
		end



		def label
			label = self.content
			label = self.title if label.blank?

			label = label + "*" if self.is_required?
			return label
		end



		private

			def set_seq
				self.seq ||= ( self.survey.questions.maximum( :seq ) || 0 ) + 1
			end

			def set_title
				self.title = self.content.parameterize if ( self.title.blank? && self.content.present? )
			end

	end
end
