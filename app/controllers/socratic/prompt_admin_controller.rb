module Socratic
	class PromptAdminController < SwellMedia::AdminController

		def create
			@prompt = Prompt.new( prompt_params )
			@prompt.save
			redirect_back( fallback_location: survey_admin_index_path )
		end

		private
			def prompt_params
				params.require( :prompt ).permit( :question_id, :content, :seq, :prompt_type, :is_correct )
			end


	end
end