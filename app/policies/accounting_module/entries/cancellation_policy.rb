module AccountingModule
  module Entries
    class CancellationPolicy < ApplicationPolicy

      def new?
        user.accountant? || user.bookkeeper?
      end

      def create?
        new?
      end
    end
  end
end
