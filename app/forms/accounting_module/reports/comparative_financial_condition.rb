module AccountingModule
  module Reports
    class ComparativeFinancialCondition
      COMPARISON_TYPES= ["monthly", "quarterly", "annually"]
      include ActiveModel::Model
      attr_accessor :comparison_type, :from_date, :to_date
      def save
        ActiveRecord::Base.transaction do
          create_financial_condition_comparison
        end
      end
    end
  end
end
