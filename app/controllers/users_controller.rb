class UsersController < ApplicationController
  def show
    @user = User.find(params[:id])
    authorize @user
  end
  def edit
    @user = User.find(params[:id])
    authorize @user
  end
  def update
    @user = User.find(params[:id])
    authorize @user

    @user.update(user_params)
    if @user.save
      redirect_to @user, notice: "Password updated successfully."
    else
      render :edit
    end
  end

  private
  def user_params
    params.require(:user).permit(:first_name, :last_name, :email, :password, :password_confirmation, :department_id, :role, :avatar)
  end
end
