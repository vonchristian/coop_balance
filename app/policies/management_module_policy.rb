class ManagementModulePolicy < ApplicationPolicy
  def index?
    user.general_manager?
  end
end
