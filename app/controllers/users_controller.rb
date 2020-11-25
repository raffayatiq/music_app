class UsersController < ApplicationController
	skip_before_action :require_login, only: [:new, :create]
	
	def new
		@user = User.new
		render :new
	end

	def create
		@user = User.new(user_params)
		
		if @user.save
			login!(@user)
			redirect_to artists_url
		else
			flash.now[:errors] = @user.errors.full_messages
			render :new
		end
	end

	private
	def user_params
		params.require(:user).permit(:email, :password)
	end
end