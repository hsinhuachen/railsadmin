class ProjectsController < ApplicationController
	def index
		if params[:name]
			# @posts = Project.category(params[:category])
			@pagy, @posts = pagy(Project.category(params[:name]))
		else
			#@posts = Project.where(published: true)
			@pagy, @posts = pagy(Project.where(published: true))
		end

		@tags = Tag.where(publish: true)

		# ----------------------------
		@projects = Project.all

		respond_to do |format|
			format.html
			format.csv { send_data @projects.to_csv, filename: "project-#{Date.today}.csv" }
		end
	end

	# GET /projects/1
	def show
		@post = Project.find(params[:id])
	end
end
