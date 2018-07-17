module Socratic
	class SurveyAdminController < SwellMedia::AdminController

		before_action :get_survey, except: [ :create, :index ]

		def create
			@survey = Survey.create( survey_params )
			redirect_back fallback_location: '/survey_admin'
		end

		def destroy
			@survey.archive!
			redirect_to survey_admin_index_path
		end

		def edit

		end


		def index
			@surveys = Survey.all.page( params[:page] )
		end

		def responses
			@survey = Survey.friendly.find( params[:id] )
		end

		def update
			@survey.update( survey_params )
			redirect_back fallback_location: '/survey_admin'
		end


		private

			def get_survey
				@survey = Survey.friendly.find( params[:id] )
			end

			def survey_params
				params.require( :survey ).permit( :title, :description )
			end
	end
end