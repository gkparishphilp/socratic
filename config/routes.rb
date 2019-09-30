Socratic::Engine.routes.draw do

	resources 	:question_admin
	resources 	:survey_admin do 
		get :responses, on: :member
	end

	resources 	:prompt_admin # just admin

	resources :surveying_admin

	resources 	:responses do
		post :save_batch, on: :collection
	end

end
