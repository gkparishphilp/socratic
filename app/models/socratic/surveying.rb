module Socratic
	class Surveying < ApplicationRecord

		enum status: { 'draft' => 0, 'active' => 1, 'complete' => 3 }

		belongs_to	 	:survey 
		belongs_to		:user

		has_many 		:responses, dependent: :destroy

		accepts_nested_attributes_for :responses


	end
end
