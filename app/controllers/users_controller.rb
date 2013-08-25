class UsersController < ApplicationController
  before_filter :authenticate_user!
  before_filter :require_user_admin!

  # TODO: pagination
  def index
    @users = User.all
  end

  def show
    @user = User.find(params[:id])
  end

  def new
    @user = User.new
    set_form_path
  end

  def create
    @user = User.new(user_params)
    set_form_path
    if @user.save
      redirect_to @user, notice: 'User was successfully updated.'
    else
      render action: 'edit'
    end
  end

  def edit
    @user = User.find(params[:id])
    set_form_path
  end

  def update
    @user = User.find(params[:id])
    set_form_path

    if @user.update(user_params)
      redirect_to @user, notice: 'User was successfully updated.'
    else
      render action: 'edit'
    end
  end


  private

  def user_params
    # TODO: duplication with AccountController
    safe_params = [:password, :password_confirmation]
    safe_params += [:full_name, :email, :company, :role, :user_admin, :title] if current_user.user_admin?
    params.require(:users).permit(*safe_params)
  end

  def set_form_path
    @post_to_path
  end

  def require_user_admin!
    unless current_user.user_admin?
      redirect_to account_edit_path, notice: "I'll be watching you #{current_user.try(:full_name)}"
      return false
    end
  end

end
