module Cooperators
  class SignUpsController < ApplicationController
    layout 'signin'
    skip_before_action :authenticate_user!

    def new
      @sign_up = CooperatorsModule::SignUp.new
    end
    def create
      @sign_up = CooperatorsModule::SignUp.new(sign_up_params)
      if @sign_up.valid?
        @sign_up.process!
        redirect_to cooperator_url(id: @sign_up.cooperator.id), notice: "Account sign up successfully"
      else
        render :new
      end
    end

    private
    def sign_up_params
      params.require(:cooperators_module_sign_up).
      permit(:first_name,
             :middle_name,
             :last_name,
             :email,
             :password,
             :password_confirmation)
    end

  end
end
