module Socratic
	class PromptAdminController < ApplicationAdminController

		def create
			@prompt = Prompt.new( prompt_params )
			@prompt.seq ||= ( @prompt.question.prompts.maximum( :seq ) || 0 ) + 1
			@prompt.save

			redirect_back( fallback_location: survey_admin_index_path )
		end

		def destroy
			@prompt = Prompt.find( params[:id] )
			@prompt.destroy
			redirect_back( fallback_location: survey_admin_index_path )
		end

		def update
			@prompt = Prompt.find( params[:id] )
			@prompt.update( prompt_params )

			redirect_back( fallback_location: survey_admin_index_path )
		end

		private
			def prompt_params
				params.require( :prompt ).permit( :question_id, :title, :content, :seq, :is_correct, :score )
			end


	end
end
