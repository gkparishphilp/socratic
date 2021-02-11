module Socratic
	class Question < ApplicationRecord
		belongs_to 		:survey

		has_many 		:prompts, dependent: :destroy
		has_many 		:responses, dependent: :destroy

		before_validation	:set_seq, :set_label

		validates	:title, presence: true

		include FriendlyId
		friendly_id :sluggit, use: [ :slugged, :scoped ], scope: :survey


		def self.uis
			[ ['Text Box', 'text_box' ], [ 'Text Area', 'text_area'], ['Radio Buttons', 'radio'], ['Check Box', 'check_box' ], ['Check Box Group', 'checkbox_group' ], ['Select', 'select' ], ['Star Rating', 'star_rating'], ['Date', 'date'], ['Agree Box', 'agree_box'] ]
		end


		def clone!( args={} )

			cloned = Question.create( 
				survey_id: self.survey_id,
				title: "#{self.title} (copy)", 
				content: self.content,
				description: self.description,
				data_label: self.data_label,
				question_ui: self.question_ui,
				seq: self.seq + 1,
				is_required: self.is_required,
				default_prompt: self.default_prompt,
				preface: self.preface,
				question_group: self.question_group,
				bind_data_field: self.bind_data_field,
				question_style: self.question_style,
				question_classes: self.question_classes
			)

			self.prompts.each do |p|
				cloned.prompts.create(
					content: p.content,
					seq: p.seq,
					value: p.value,
					is_correct: p.is_correct,
					title: p.title
				)
			end

			return cloned

		end


		def sluggit
			self.data_label || self.title
		end



		private

			def set_label
				self.data_label ||= self.title.parameterize
			end
			def set_seq
				if not( self.seq.present? )
					self.seq = ( self.survey.questions.maximum( :seq ) || 0 ) + 1
				end
			end

	end
end
