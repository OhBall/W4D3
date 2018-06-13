class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  
  helper_method :current_user
  
  def current_user
    user = User.find_by(session_token: session[:session_token])
  end
  
  def login_user!
    user = User.find_by(username: params[:session][:username])
    if user
      user.reset_session_token!
      session[:session_token] = user.session_token
      redirect_to cats_url
    else 
      redirect_to new_session_url
    end 
  end 
  
  def logged_in?
    !!current_user
  end
  
  def ensure_logged_out
    redirect_to cats_url if logged_in?
  end
  
  def ensure_owner
    cat = current_user.cats.where(id: params[:id])
    redirect_to cat_url if cat.empty?
  end  
end
