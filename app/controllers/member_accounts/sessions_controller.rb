module MemberAccounts
  class SessionsController < Devise::SessionsController
    layout 'members'
    skip_before_action :authenticate_user!
  end
end
