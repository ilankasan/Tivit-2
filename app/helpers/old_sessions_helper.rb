module OldSessionsHelper
    
  def old_sign_in(user)
    cookies.permanent.signed[:remember_token] = [user.id, user.salt]
    self.current_user = user
    
    puts "****************  update last sign in *****************************"
     
    user.update_last_signin
    puts "****************  update last sign in *****************************"
    
  end
  
  
  def old_sign_out
    cookies.delete(:remember_token)
    self.current_user = nil
  end
  
  
  def old_current_user=(user)
    @current_user = user
  end
  
  def current_user
    account_current_account.user
  end
  
  def _oldsigned_in?
    !current_user.nil?
  end
  
  def deny_access
    redirect_to signin_path, :notice => "Please sign in to access this page."
  end
  
  def current_user?(user)
    user == current_user
  end
  
  
    
  def deny_access
    store_location
    redirect_to signin_path, :notice => "Please sign in to access this page - option 1."
  end

  def redirect_back_or(default)
    redirect_to(session[:return_to] || default)
    clear_return_to
  end
  
  
  
  
  def old_authenticate
    deny_access unless signed_in?
  end

  
  
 private

    
    def store_location
      session[:return_to] = request.fullpath
    end

    def clear_return_to
      session[:return_to] = nil
    end
    
    def user_from_remember_token
      User.authenticate_with_salt(*remember_token)
    end

    def remember_token
      cookies.signed[:remember_token] || [nil, nil]
    end
    
    
end