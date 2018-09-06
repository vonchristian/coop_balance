module MemberAccounts
  class RegistrationsController < ApplicationController
    layout 'members'
    skip_before_action :authenticate_user!, only: [:new, :create]
    def new
      @member_account = MemberAccounts::AccountRegistration.new
    end
    def create
      @member_account = MemberAccounts::AccountRegistration.new(registration_params)
      if @member_account.valid?
        @member_account.register!
        redirect_to new_member_account_session_url, notice: "Account successfully created."
      else
        render :new
      end
    end

    private
    def registration_params
      params.require(:member_accounts_account_registration).
      permit(:first_name, :middle_name, :last_name, :email, :password, :password_confirmation, :account_number)
    end
  end
end
