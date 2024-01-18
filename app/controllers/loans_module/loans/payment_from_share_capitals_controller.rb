module LoansModule
  module Loans
    class PaymentFromShareCapitalsController < ApplicationController
      def new
        @loan = current_office.loans.find(params[:loan_id])
        @borrower_share_capitals = @loan.borrower.share_capitals
        @payment_voucher = LoansModule::Loans::PaymentVoucher.new
        if params[:search].present?
          @pagy, @share_capitals = pagy(current_office.share_capitals.text_search(params[:search]))
        else
          @pagy, @share_capitals = pagy(current_office.share_capitals.where.not(id: @borrower_share_capitals.ids))
        end
      end
    end
  end
end
