module Admin
  module Settings
    class UsersController < ApplicationController
      def new
        @user = User.new
        authorize @user
      end
      def create
        @user = User.create(user_params)
        authorize @user
        if @user.save
          redirect_to bplo_section_settings_url, notice: 'User created successfully.'
        else
          render :new
        end
      end

      def show
        @user = User.find(params[:id])
        authorize @user
      end

      private
      def user_params
        params.require(:user).permit(:first_name, :last_name, :email, :password, :password_confirmation, :department_id, :role, :avatar)
      end
    end
  end
end
