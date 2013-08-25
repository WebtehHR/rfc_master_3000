class AccountController < ApplicationController

  before_filter :authenticate_user!
  before_filter :set_user_and_edit_path, only: [:edit, :update]

  def edit
  end

  def update
    if @user.update(account_params)
      redirect_to @user, notice: 'Your account was successfully updated.'
    else
      render action: 'edit'
    end
  end

  
  private

  def account_params
    safe_params = [:password, :password_confirmation]
    safe_params += [:full_name, :email, :company, :role, :user_admin, :title] if current_user.user_admin?
    params.require(:users).permit(*safe_params)
  end

  def set_user_and_edit_path
    @user = current_user
    @post_to_path = account_edit_path
  end

end
