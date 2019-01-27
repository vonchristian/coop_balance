module TreasuryModule
  module Summaries
    class CashBooksController < ApplicationController
      def index
        @from_date = Date.current
        @to_date   = Date.current
      end
    end
  end
end
