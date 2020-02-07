module Socratic
	class Survey < ApplicationRecord

		enum status: { 'draft' => 0, 'active' => 1, 'archive' => 3, 'trash' => 9 }

		#has_many 		:pages, dependent: :destroy
		has_many 		:questions, dependent: :destroy
		has_many 		:surveyings, dependent: :destroy


		include FriendlyId
		friendly_id :title, use: [ :slugged, :history ]

	end
end
