module HrModule 
  class SettingsPolicy < ApplicationPolicy 
    def index?
      user.human_resource_officer?
    end 
  end 
end 