class ManagementModulePolicy < ApplicationPolicy 
  def index?
    user.manager?
  end 
end 