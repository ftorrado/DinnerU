# Helper for handling user sessions used throughout the application
module SessionsHelper
  # Logs user in
  def log_in(user)
    session[:user_id] = user.id
  end

  # Remembers a user in a persistent session.
  def remember(user)
    user.remember
    if user.is_guest
      cookies.permanent.signed[:guest_id] = user.id
    else
      cookies.permanent.signed[:user_id] = user.id
    end
    cookies.permanent[:remember_token] = user.remember_token
  end

  # Gets the logged in user, if any
  def current_user
    if (user_id = session[:user_id])
      @current_user ||= User.find_by(id: user_id)
    elsif (user_id = cookies.signed[:user_id])
      user = User.find_by(id: user_id)
      if user && user.authenticated?(cookies[:remember_token])
        log_in user
        @current_user = user
      end
    end
  end

  # If user is logged in, return current_user, else return guest_user
  def current_or_guest_user
    if current_user
      if session[:guest_id] && session[:guest_id] != current_user.id
        upgrade_user
        # reload guest_user to prevent caching problems before destruction
        guest_user(with_retry = false).reload.try(:destroy)
        session[:guest_user_id] = nil
      end
      current_user
    else
      guest_user
    end
  end

  # Gets current guest_user, creating one as needed
  def guest_user(with_retry = true)
    @guest_user ||= User.find(session[:guest_id] ||= create_guest_user.id)

  rescue Mongoid::Errors::DocumentNotFound
    session[:guest_id] = nil
    guest_user if with_retry
  end

  # Checks if any user is logged in
  def logged_in?
    !current_user.nil?
  end

  # Forgets a persistent session.
  def forget(user)
    user.forget
    cookies.delete(:user_id)
    cookies.delete(:remember_token)
  end

  # Logs out the current user.
  def log_out
    forget(current_user)
    session.delete(:user_id)
    @current_user = nil
  end

  private

    # Call this once when user logs in as full user, handing off
    # guest_user data to the new current_user
    def upgrade_user
      # TODO
      # pass user references to current_user
      # delete guest_user
    end

    # Creates and returns a new guest user
    def create_guest_user
      user = User.create(name: "guest_#{rand(1000000)}",
                         is_guest: true)
      user.save!(:validate => false)
      session[:guest_id] = user.id
      user
    end
end
