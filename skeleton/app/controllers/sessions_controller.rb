class SessionsController <ApplicationController 
  
  before_action :ensure_logged_out, only:[:new]
  
  def new
    user = User.new
    render :new
  end
  
  def create
    login_user!
  end
  
  def destroy
    current_user.reset_session_token! if current_user
    session[:session_token] = nil
    redirect_to new_session_url
  end
end 
