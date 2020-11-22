class SessionsController < ApplicationController
	def new
		@user = User.new
		render :new
	end

	def create
		@user = User.find_by_credentials(
			params[:user][:email],
			params[:user][:password]
			)

		if @user.nil?
			@user = User.new(
				email: params[:user][:email],
				password: params[:user][:password]
				)
			flash.now[:errors] = ["Invalid username or password."]
			render :new
		else
			login!(@user)
			render json: "Logged in as #{current_user.email}"
		end
	end

	def destroy
		current_user.reset_session_token!
		session[:session_token] = nil
		redirect_to new_session_url
	end
end