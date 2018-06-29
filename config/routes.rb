Socratic::Engine.routes.draw do

	resources 	:question_admin
	resources 	:survey_admin

	resources 	:prompt_admin # just admin

	resources 	:response, only: :create # to record responses one at a time
	resources	:survey_response, only: :create

end
