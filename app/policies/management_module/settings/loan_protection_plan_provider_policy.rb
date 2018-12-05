module ManagementModule
  module Settings
    class LoanProtectionPlanProviderPolicy < ApplicationPolicy
      def new?
        edit?
      end
      def create?
        new?
      end
      def edit?
        user.general_manager?
      end
      def update?
        edit?
      end
    end
  end
end
