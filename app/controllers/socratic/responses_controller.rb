module Socratic
	class ResponsesController < ApplicationController


		def create
			# record responses one at a time
		end


		def batch
			# record multiple responses for a survey

			unlocked_params = params.to_unsafe_h

			@survey = Survey.find( unlocked_params[:survey_id] )
			@user = User.find_or_create_by( email:unlocked_params[:responses][:email][:content].downcase )

			@surveying = @survey.surveyings.find_or_create_by( user: @user )
			
			unlocked_params[:responses].each do |question_slug, response_data|
				question = @survey.questions.friendly.find( question_slug )
				response = @surveying.responses.find_or_initialize_by( question: question )
				response.save
				response.update( response_data )
			end

			if @surveying.responses.where( question: @surveying.survey.questions.where( is_required: true ) ).where( content: '' ).present?
				set_flash "Please answer all required questions", :error
				redirect_to "/cb-apply?cb_application_id=#{@surveying.id}"
				return false
			end

		end

	end
end