module Socratic
	class SurveyAdminController < SwellMedia::AdminController


		def create
			@survey = Survey.create( survey_params )
			redirect_back fallback_location: '/survey_admin'
		end

		def edit
			@survey = Survey.friendly.find( params[:id] )
		end


		def index
			@surveys = Survey.all.page( params[:page] )
		end

		def update
			@survey = Survey.friendly.find( params[:id] )
			@survey.update( survey_params )
			redirect_back fallback_location: '/survey_admin'
		end


		private

			def survey_params
				params.require( :survey ).permit( :title, :description )
			end
	end
end