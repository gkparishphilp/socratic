module Socratic
	class SurveyingAdminController < ApplicationAdminController


		def destroy
			@surveying = Surveying.find( params[:id] )
			@surveying.destroy
			redirect_back( fallback_location: '/admin' )
		end

		def show
			@surveying = Surveying.find( params[:id] )
			@survey = @surveying.survey
		end
	end
	
end