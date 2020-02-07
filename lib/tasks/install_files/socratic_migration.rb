class SocraticMigration < ActiveRecord::Migration[5.1]

	def change

		create_table 	:socratic_prompts, force: true do |t|
			t.references 	:question
			t.string 		:title
			t.text 			:content
			t.integer 		:seq
			t.integer 		:value
			t.boolean 		:is_correct
			t.string 		:prompt_type, default: 'text'
			t.timestamps
		end
		add_index :socratic_prompts, [ :question_id, :seq ]

		create_table 	:socratic_questions, force: true do |t|
			t.references 	:survey
			t.refereces 	:page
			t.string 		:title
			t.string  		:name
			t.text 			:content
			t.text 			:preface
			t.string 		:question_ui, default: :text_box # text-area, radio, check-box, radio-other, check-box-other, select
			t.integer 		:seq
			t.boolean		:is_required
			t.string 		:slug
			t.string 		:question_style
			t.string 		:question_classes
			t.string 		:question_group
			t.string 		:bind_data_field
			t.string 		:default_prompt
			t.timestamps
		end
		add_index :socratic_questions, [ :survey_id, :seq ]
		add_index :socratic_questions, [ :survey_id, :slug ]

		create_table 	:socratic_responses, force: true do |t|
			t.references 	:user
			t.references 	:surveying
			t.references 	:question
			t.references 	:prompt
			t.text 			:content
			t.text 			:notes
			t.datetime 		:started_at
			t.datetime 		:completed_at
			t.timestamps
		end
		add_index :socratic_responses, [ :user_id, :surveying_id, :question_id, :prompt_id ], name: 'responses_full_idx'

		create_table 	:socratic_surveyings, force: true do |t|
			t.references 	:user
			t.references 	:survey
			t.references 	:current_question
			t.references 	:furthest_question
			t.integer 		:score
			t.text 			:notes 
			t.datetime 		:completed_at
			t.integer		:status, default: 0 		
			t.timestamps
		end
		add_index :socratic_surveyings, [ :user_id, :survey_id ]
		
		create_table 	:socratic_surveys, force: true do |t|
			t.references 	:parent_obj, polymorphic: true
			t.string		:title
			t.text 			:description
			t.string 		:survey_type
			t.integer 		:status, 			default: 1
			t.string		:slug
			t.text 			:thank_you_copy
			t.timestamps
		end
		add_index :socratic_surveys, :slug


	end

end