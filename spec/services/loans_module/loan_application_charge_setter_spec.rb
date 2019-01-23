require 'rails_helper'

module LoansModule
  describe LoanApplicationChargeSetter do
    let(:add_on_straight_line_loan_product) { create(:add_on_straight_line_loan_product) }
    let (:loan_application) { create(:loan_application, loan_product: add_on_straight_line_loan_product) }

    it "#create_interest_on_loan_charge" do
      described_class.new(loan_application: loan_application, loan_product: add_on_straight_line_loan_product).create_charges!
      puts loan_application.voucher_amounts.count
    end

    it "#loan_product_charges" do
    end
    it "#create_loan_protection_fund" do
    end
    it "#interest_amount" do
    end

    it "#interest_account" do
    end
  end
end
