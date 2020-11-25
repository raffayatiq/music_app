class ApplicationController < ActionController::Base
	helper_method :current_user
	helper_method :logged_in?
	before_action :require_login

	def login!(user)
		session[:session_token] = user.reset_session_token!
	end

	def logged_in?
		!current_user.nil?
	end

	def current_user
		@current_user ||= User.find_by(session_token: session[:session_token])
	end

	def require_login
		redirect_to new_session_url if !logged_in?
	end

	def redirect_if_logged_in
		redirect_to artists_url if logged_in?
	end
end
