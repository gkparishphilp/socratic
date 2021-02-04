module Socratic
	class Survey < ApplicationRecord

		enum status: { 'draft' => 0, 'active' => 1, 'archive' => 3, 'trash' => 9 }

		#has_many 		:pages, dependent: :destroy
		has_many 		:questions, dependent: :destroy
		has_many 		:surveyings, dependent: :destroy


		include FriendlyId
		friendly_id :title, use: [ :slugged, :history ]



		def clone!( args={} )
			parent_id = args[:parent].try( :id ) || args[:parent_obj_id] || args[:parent_id] || self.parent_obj_id
			parent_type = args[:parent].try( :class ).try( :name) || args[:parent_obj_type] || args[:parent_type] || self.parent_obj_type

			cloned = Survey.create( 
				title: "#{self.title} (copy)", 
				description: self.description,
				survey_type: self.survey_type,
				parent_obj_id: parent_id,
				parent_obj_type: parent_type,
				template: self.template,
				layout: self.layout,
				preface: self.preface,
				thank_you_copy: self.thank_you_copy,
				require_login: self.require_login
			)

			self.questions.order( seq: :asc ).each do |q|
				new_question = cloned.questions.create(
					title: q.title,
					content: q.content,
					question_ui: q.question_ui,
					seq: q.seq,
					is_required: q.is_required,
					#page_id: q.page_id,
					question_group: q.question_group,
					bind_data_field: q.bind_data_field,
					default_prompt: q.default_prompt,
					description: q.description,
					preface: q.preface,
					question_style: q.question_style,
					question_classes: q.question_classes
				)
				q.prompts.order( seq: :asc ).each do |p|
					new_question.prompts.create(
						content: p.content,
						seq: p.seq,
						value: p.value,
						is_correct: p.is_correct,
						title: p.title
					)
				end
			end

			return cloned

		end

	end
end
