class SessionsController <ApplicationController 
  def new
    render :new
  end
  
  def create
    user = User.find_by(params[:user][:username])
    if user
      user.reset_session_token!
      session[:session_token] = user.session_token
      redirect_to cats_url
    else 
      redirect_to new_sessions_url
    end 
  end
  
  def destroy
  end
end 
