module Socratic
	class QuestionAdminController < SwellMedia::AdminController

		before_action :get_question, except: :create

		def create
			@question = Question.new( question_params )

			@question.save
			redirect_back fallback_location:  edit_question_admin_path( @question )
			#redirect_to edit_question_admin_path( @question )
		end

		def destroy
			@question.destroy
			redirect_to survey_admin_edit_path( question.survey )
		end

		def edit
			
		end

		def update
			@question.update( question_params )
			redirect_back fallback_location: edit_survey_admin_path( @question.survey )
		end

		private
			def get_question
				@question = Question.friendly.find params[:id]
			end

			def question_params
				params.require( :question ).permit( :survey_id, :title, :content, :question_ui, :seq, :is_required )
			end

	end


end