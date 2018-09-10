module Socratic
	class SurveyingAdminController < ApplicationAdminController

		def show
			@surveying = Surveying.find( params[:id] )
			@survey = @surveying.survey
		end
	end
end