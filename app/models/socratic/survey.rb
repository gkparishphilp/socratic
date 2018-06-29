module Socratic
	class Survey < ApplicationRecord
		has_many 		:questions
		has_many 		:surveyings


		include FriendlyId
		friendly_id :title, use: [ :slugged, :history ]

	end
end
