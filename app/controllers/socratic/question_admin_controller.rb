module Socratic
	class QuestionAdminController < SwellMedia::AdminController

		def create
			
		end

		private
			def question_attributes
				params.require( :question ).permit( :title, :content, :question_type, :is_required )
			end

	end


end