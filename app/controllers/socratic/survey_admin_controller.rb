module Socratic
	class SurveyAdminController < ApplicationAdminController

		before_action :get_survey, except: [ :create, :index ]


		def clone
			cloned = @survey.clone!
			redirect_to edit_survey_admin_path( cloned.id )
		end


		def create
			@survey = Survey.create( survey_params )
			redirect_to edit_survey_admin_path( @survey.id )
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
					prefix_headers = [ 'Email', 'First Name', 'Last Name', 'Created', 'Completed', 'gender', 'dob', 'street', 'street2', 'city', 'state', 'zip', 'country', 'phone', 'height', 'weight' ]

					headers = prefix_headers + @survey.questions.order( seq: :asc, id: :asc ).pluck( :data_label )
					question_index_lookup = @survey.questions.order( seq: :asc, id: :asc ).pluck( :id ).map.with_index(prefix_headers.count).to_h

					csv << headers

					sql = <<-SQL
SELECT sing.id as "surveying_id", u.id as "user_id", u.email, u.first_name, u.last_name, bp.gender, bp.dob, bp.street, bp.street2, bp.city, bp.state, bp.zip, bp.country, bp.phone, bp.height, bp.weight, sing.created_at, sing.completed_at, q.seq, r.content, r.score, q.data_label, q.id "question_id"
FROM users u
INNER JOIN beta_profiles bp ON bp.user_id = u.id
INNER JOIN socratic_surveyings sing ON sing.user_id = u.id
LEFT JOIN socratic_responses r ON r.surveying_id = sing.id
LEFT JOIN socratic_questions q ON q.id = r.question_id
LEFT JOIN socratic_surveys s ON q.survey_id = s.id
WHERE sing.survey_id = #{@survey.id}
GROUP BY q.id, u.id, sing.id, bp.id, r.id
ORDER BY u.email ASC, q.seq ASC
SQL

					response = ActiveRecord::Base.connection.execute( sql )
					surveying_rows = {}

					# Group the Responses into Rows Based on surveying id
					response.each do |row|
						# initialize the surveying row with email, created at and completed at data
						surveying_rows[row['surveying_id']] ||= [ row['email'], row['first_name'], row['last_name'], row['created_at'], row['completed_at'], row['gender'], row['dob'], row['street'], row['street2'], row['city'], row['state'], row['zip'], row['country'], row['phone'], row['height'], row['weight'] ]
						surveying_row = surveying_rows[row['surveying_id']]

						question_id = row['question_id']

						if question_id.present?
							question_row_index = question_index_lookup[question_id]
							surveying_row[question_row_index] = row['content']
						end

						surveying_rows[row['surveying_id']] = surveying_row
					end

					surveying_rows.each do |surveying_id,surveying_row|
						csv << surveying_row
					end
				end
			end

			@surveyings = @surveyings.page( params[:page] )

			respond_to do |format|
				format.html
				format.csv { send_data @csv, filename: "#{@survey.title}-survey_data-#{Date.today}.csv" }
			end


		end


		def orig_responses
			sort_by = params[:sort_by] || 'created_at'
			sort_dir = params[:sort_dir] || 'desc'

			@surveyings = @survey.surveyings.order( "#{sort_by} #{sort_dir}" )

			if params[:status].present? && params[:status] != 'all'
				@surveyings = eval "@surveyings.#{params[:status]}"
			end


			if request.format.to_s == 'text/csv'
				@csv = CSV.generate( headers: true ) do |csv|
					prefix_headers = [ 'Email', 'First Name', 'Last Name', 'Created', 'Completed' ]
					headers = prefix_headers + @survey.questions.order( seq: :asc, id: :asc ).pluck( :data_label )
					question_index_lookup = @survey.questions.order( seq: :asc, id: :asc ).pluck( :id ).map.with_index(prefix_headers.count).to_h

					csv << headers

					sql = <<-SQL
SELECT sing.id as "surveying_id", u.id as "user_id", u.email, u.first_name, u.last_name, sing.created_at, sing.completed_at, q.seq, STRING_AGG( r.content, ';' ) as "content", q.data_label, q.id "question_id"
FROM users u
INNER JOIN socratic_surveyings sing ON sing.user_id = u.id
LEFT JOIN socratic_responses r ON r.surveying_id = sing.id
LEFT JOIN socratic_questions q ON q.id = r.question_id
LEFT JOIN socratic_surveys s ON q.survey_id = s.id
WHERE sing.survey_id = #{@survey.id}
GROUP BY q.id, u.id, sing.id
ORDER BY u.email ASC, q.seq ASC
SQL

					response = ActiveRecord::Base.connection.execute( sql )
					surveying_rows = {}

					# Group the Responses into Rows Based on surveying id
					response.each do |row|
						# initialize the surveying row with email, created at and completed at data
						surveying_rows[row['surveying_id']] ||= [ row['email'], row['first_name'], row['last_name'], row['created_at'], row['completed_at'] ]
						surveying_row = surveying_rows[row['surveying_id']]

						question_id = row['question_id']

						if question_id.present?
							question_row_index = question_index_lookup[question_id]
							surveying_row[question_row_index] = row['content']
						end

						surveying_rows[row['surveying_id']] = surveying_row
					end

					surveying_rows.each do |surveying_id,surveying_row|
						csv << surveying_row
					end
				end
			end

			@surveyings = @surveyings.page( params[:page] )

			respond_to do |format|
				format.html
				format.csv { send_data @csv, filename: "#{@survey.title}-survey_data-#{Date.today}.csv" }
			end


		end

		def update
			@survey.slug = nil if ( params[:survey][:title] != @survey.title ) || ( params[:survey][:slug_pref].present? )
			@survey.update( survey_params )
			redirect_back fallback_location: '/survey_admin'
		end


		private

			def get_survey
				@survey = Survey.find( params[:id] )
			end

			def survey_params
				params.require( :survey ).permit( :title, :description, :status, :preface, :thank_you_copy, :survey_type, :parent_obj_id, :parent_obj_type, :starts_at, :ends_at, :require_login, :parent_obj_id, :parent_obj_type, :template, :ttl )
			end
	end
end
