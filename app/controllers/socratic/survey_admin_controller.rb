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

					sql = <<-SQL
SELECT sing.id as "surveying_id", u.id as "user_id", u.email, sing.created_at, sing.completed_at, q.seq, STRING_AGG( r.content, ';' ) as "content"
FROM users u
INNER JOIN socratic_surveyings sing ON sing.user_id = u.id
INNER JOIN socratic_responses r ON r.surveying_id = sing.id
INNER JOIN socratic_questions q ON q.id = r.question_id
INNER JOIN socratic_surveys s ON q.survey_id = s.id
WHERE q.survey_id = #{@survey.id}
GROUP BY q.id, u.id, sing.id
ORDER BY u.email ASC, q.seq ASC
SQL

					response = ActiveRecord::Base.connection.execute( sql )
					surveying_rows = {}

					# Group the Responses into Rows Based on surveying id
					response.each do |row|
						# initialize the surveying row with email, created at and completed at data
						surveying_rows[row['surveying_id']] ||= [ row['email'], row['created_at'], row['completed_at'] ]
						surveying_row = surveying_rows[row['surveying_id']]

						# Add in the responses, one question at a time, offset by the number
						# offset by 2, -1 (seq is base 1) + 3 (leading columns), to account
						# for the 3 leading columns.
						surveying_row[row['seq'].to_i + 2] = row['content']
					end

					surveying_rows.each do |surveying_id,surveying_row|
						csv << surveying_row
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
			@survey.slug = nil if ( params[:survey][:title] != @survey.title ) || ( params[:survey][:slug_pref].present? )
			@survey.update( survey_params )
			redirect_back fallback_location: '/survey_admin'
		end


		private

			def get_survey
				@survey = Survey.friendly.find( params[:id] )
			end

			def survey_params
				params.require( :survey ).permit( :title, :description, :status, :preface, :thank_you_copy, :survey_type, :parent_obj_id, :parent_obj_type, :starts_at, :ends_at, :require_login, :parent_obj_id, :parent_obj_type, :template )
			end
	end
end
