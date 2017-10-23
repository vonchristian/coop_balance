module ManagementModule 
  module Settings 
    class CooperativePolicy < ApplicationPolicy
      def edit?
        user.manager?
      end 
      def update?
        edit?
      end 
    end 
  end 
end 