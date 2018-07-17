module Socratic
	class SurveyingAdminController < SwellMedia::AdminController

		def show
			@surveying = Surveying.find( params[:id] )
			@survey = @surveying.survey
		end
	end
end