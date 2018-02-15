module StoreFrontModule
  module Reports
    class SalesClerkReportsController < ApplicationController
      def index
        @employee = current_user
      end
    end
  end
end
