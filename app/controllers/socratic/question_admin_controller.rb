module Socratic
	class QuestionAdminController < SwellMedia::AdminController

		before_action :get_question, except: :create

		def create
			@question = Question.new( question_attributes )
			@question.save
			redirect_to edit_question_admin_path( @question )
		end

		def destroy
			@question.destroy
			redirect_to survey_admin_edit_path( question.survey )
		end

		def edit
			
		end

		def update
			@question.update( question_params )
			redirect_back fallback_location: survey_admin_edit_path( question.survey )
		end

		private
			def get_question
				@question = Question.find params[:id]
			end

			def question_attributes
				params.require( :question ).permit( :survey_id, :label, :content, :question_type, :seq, :is_required )
			end

	end


end