module Socratic
	class Surveying < ApplicationRecord
		belongs_to	 	:survey 
		belongs_to		:user

		has_many 		:responses, dependent: :destroy

		accepts_nested_attributes_for :responses
	end
end
