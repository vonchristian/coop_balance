module ManagementModule
  module Settings
    class CooperativePolicy < ApplicationPolicy
      def edit?
        user.general_manager?
      end

      def update?
        edit?
      end
    end
  end
end
