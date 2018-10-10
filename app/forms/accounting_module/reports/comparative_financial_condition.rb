module AccountingModule
  module Reports
    class ComparativeFinancialCondition
      include ActiveModel::Model
      attr_accessor :comparison_type, :first_date, :second_date

      def save
        ActiveRecord::Base.transaction do
          create_financial_condition_comparison
        end
      end

      private
      def create_financial_condition_comparison
        AccountingModule::FinancialConditionComparison.create(
          comparison_type: comparison_type,
          first_date: first_date,
          second_date: second_date)
      end
    end
  end
end
