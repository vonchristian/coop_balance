class UsersController < ApplicationController
  def show
    @user = current_cooperative.users.find(params[:id])
    authorize @user
  end
  def edit
    @user = current_cooperative.users.find(params[:id])
    authorize @user
  end
  def update
    @user = current_cooperative.users.find(params[:id])
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
    params.require(:user).permit(:first_name, :last_name, :email, :password, :password_confirmation,  :role, :avatar)
  end
end
