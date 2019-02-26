class UserProfileController < ApplicationController

  def edit
    @user = current_user
  end

  def update
    @user = User.find(current_user.id)
    if @user.update(profile_params)
      redirect_to user_profile_path, notice: "Profile updated!"
    else
      render :edit
    end
  end

  private

  def profile_params
    params.require(:user).permit(:email, :first_name, :last_name)
  end
end