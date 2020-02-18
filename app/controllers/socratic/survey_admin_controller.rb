module Socratic
	class SurveyAdminController < ApplicationAdminController

		before_action :get_survey, except: [ :create, :index ]


		def clone
			cloned = @survey.clone!
			redirect_to edit_survey_admin_path( cloned )
		end


		def create
			@survey = Survey.create( survey_params )
			redirect_to edit_survey_admin_path( @survey )
			#redirect_back fallback_location: '/survey_admin'
		end

		def destroy
			@survey.destroy
			redirect_to survey_admin_index_path
		end

		def edit

		end


		def index
			@surveys = Survey.all.page( params[:page] )
		end

		def responses
			sort_by = params[:sort_by] || 'created_at'
			sort_dir = params[:sort_dir] || 'desc'

			@surveyings = @survey.surveyings.order( "#{sort_by} #{sort_dir}" )

			if params[:status].present? && params[:status] != 'all'
				@surveyings = eval "@surveyings.#{params[:status]}"
			end


			if request.format.to_s == 'text/csv'
				@csv = CSV.generate( headers: true ) do |csv|
					headers = [ 'email', 'created_at', 'completed_at' ]
					headers = headers + @survey.questions.order( :seq ).pluck( :name )
					csv << headers
					@surveyings.each do |surveying|
						row = [ surveying.user.email, surveying.created_at, surveying.completed_at ]
						@survey.questions.order( :seq ).each do |q|
							row << surveying.responses.where( question: q ).pluck( :content ).reject{ |c| c.nil? }.join( '; ' )
						end
						csv << row
					end
				end
			end

			@surveyings = @surveyings.page( params[:page] )

			respond_to do |format|
				format.html
				format.csv { send_data @csv, filename: "survey_data-#{Date.today}.csv" }
			end


		end

		def update
			@survey.update( survey_params )
			redirect_back fallback_location: '/survey_admin'
		end


		private

			def get_survey
				@survey = Survey.friendly.find( params[:id] )
			end

			def survey_params
				params.require( :survey ).permit( :title, :description, :status, :preface, :thank_you_copy, :survey_type, :parent_obj_id, :parent_obj_type, :starts_at, :ends_at, :require_login, :parent_obj_id, :parent_obj_type )
			end
	end
end