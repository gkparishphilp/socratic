module Socratic
	class Question < ApplicationRecord
		belongs_to 		:survey

		has_many 		:prompts, dependent: :destroy
		has_many 		:responses, dependent: :destroy

		before_validation	:set_seq, :set_name

		validates	:title, presence: true

		include FriendlyId
		friendly_id :name, use: [ :slugged, :scoped ], scope: :survey


		def self.uis
			[ ['Text Box', 'text_box' ], [ 'Text Area', 'text_area'], ['Radio Buttons', 'radio'], ['Check Box', 'check_box' ], ['Check Box Group', 'check_box_group' ], ['Select', 'select' ], ['Date', 'date'], ['Agree Box', 'agree_box'] ]
		end



		private

			def set_seq
				self.seq ||= ( self.survey.questions.maximum( :seq ) || 0 ) + 1
			end

			def set_name
				self.name = self.title.parameterize if ( self.name.blank? && self.title.present? )
			end

	end
end
