module AccountingModule
  class FinancialConditionComparison < ApplicationRecord
    enum comparison_type: [:monthly, :quarterly, :yearly]

    def first_date_display_title
      if monthly?
        first_date.strftime("%B %Y")
      elsif yearly?
        first_date.strftime("%Y")
      end
    end
    def second_date_display_title
      if monthly?
        second_date.strftime("%B %Y")
      elsif yearly?
        second_date.strftime("%Y")
      end
    end
    def first_comparison_date
      if monthly?
        first_date.end_of_month
      elsif quarterly?
        first_date.end_of_quarter
      elsif yearly?
        first_date.end_of_year
      end
    end

    def second_comparison_date
      if monthly?
        second_date.end_of_month
      elsif quarterly?
        second_date.end_of_quarter
      elsif yearly?
        second_date.end_of_year
      end
    end
  end
end
