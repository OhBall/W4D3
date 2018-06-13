class UsersController <ApplicationController
  
  def new 
    render :new
  end 
  
  def create 
    user = User.new(user_params)
    
    if user.save 
      user.reset_session_token!
      session[:session_token] = user.session_token
      redirect_to cats_url
    else 
      render json: user.errors.full_messages, status: 422
    end 
  end 
  
  
  private 
  
  def user_params 
    params.require(:user).permit(:username, :password)
  end 
end 