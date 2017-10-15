module HrModule 
  class SalaryGradePolicy < ApplicationPolicy 
    def new?
      user.human_resource_officer?
    end 
    def create?
      new?
    end 
  end 
end 