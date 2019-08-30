class UserProfileController < ApplicationController

  def edit
    @user = current_user
  end

  def update
    @user = User.find(current_user.id)
    if (profile_params.key?(:current_password) ? @user.update_with_password(profile_params) : @user.update(profile_params))
      bypass_sign_in(@user)
      redirect_to user_profile_path, notice: "Profile updated!"
    else
      render :edit
    end
  end

  private

  def profile_params
    attrs = params.require(:user).permit(:email, :first_name, :last_name, :time_zone, :phone, :current_password, :password, :password_confirmation)
    # remove the password fields if they aren't trying to change their password
    unless %w[current_password password password_confirmation].any? { |key| attrs.dig(key).present?  }
      attrs.extract!('current_password', 'password', 'password_confirmation')
    end
    attrs
  end
end