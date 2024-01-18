module AccountingModule
  class FinancialConditionComparison < ApplicationRecord
    enum comparison_type: { daily: 0, weekly: 1, monthly: 2, quarterly: 3, semi_annually: 4, yearly: 5 }

    def first_date_display_title
      if yearly?
        first_date.strftime('%Y')
      else
        first_date.strftime('%B %Y')
      end
    end

    def second_date_display_title
      if yearly?
        second_date.strftime('%Y')
      else
        second_date.strftime('%B %Y')
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
