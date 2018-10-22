class MemberAccountsController < ApplicationController
  layout 'members'
  skip_before_action :authenticate_user!
  def show
    @member_account = current_member_account
  end
end
