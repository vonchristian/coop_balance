module LoansModule
  module Notices
    class FirstNotice < Notice
      def date_for(loan)
        loan.maturity_date + 10.days
      end
    end
  end
end
