module SessionsHelper
  # implements persistent sessions 
  
  # appears in both SessionsController and UsersController
  def sign_in(user)
    cookies.permanent.signed[:remember_token] = [user.id, user.salt]
    self.current_user = user
  end

  def sign_out
    cookies.delete(:remember_token)
    self.current_user = nil
  end

  def current_user=(user)
    # setting is done normally...
    @current_user = user
  end

  def current_user
    # but we consult remember_token to find out who the current user is 
    @current_user ||= user_from_remember_token
  end

  def signed_in?
    !current_user.nil?
  end

  private

    def user_from_remember_token
      User.authenticate_with_salt(*remember_token)
    end

    def remember_token
      cookies.signed[:remember_token] || [nil, nil]
    end

end
