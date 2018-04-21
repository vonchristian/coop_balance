module LoansModule
  class LoanApplicationForm
    include ActiveModel::Model
    include ActiveModel::Callbacks
    attr_accessor :borrower_id,
                  :borrower_type,
                  :term,
                  :loan_product_id,
                  :loan_amount,
                  :application_date,
                  :mode_of_payment,
                  :application_date,
                  :account_number,
                  :preparer_id
    def save
      ActiveRecord::Base.transaction do
        save_loan
      end
    end
    def find_loan
      LoansModule::Loan.find_by(account_number: account_number)
    end

    private
    def find_borrower
      employee_borrower = User.find_by_id(borrower_id)
      member_borrower = Member.find_by_id(borrower_id)
      if member_borrower.present?
        member_borrower
      elsif employee_borrower.present?
        employee_borrower
      end
    end

    def save_loan
      loan = find_borrower.loans.create!(
        loan_product_id: loan_product_id,
        loan_amount: loan_amount,
        term: term,
        application_date: application_date,
        mode_of_payment: mode_of_payment,
        preparer_id: preparer_id,
        account_number: account_number)
      create_loan_product_charges(loan)
      create_amortization_schedule(loan)
      # create_documentary_stamp_tax(loan)
    end

    def create_loan_product_charges(loan)
      loan_charges = LoansModule::LoanCharge.where(loan: loan)
      if loan_charges.present?
        loan_charges.destroy_all
      end
      loan.loan_product.create_charges_for(loan)
    end

    def create_documentary_stamp_tax(loan)
       tax = Charge.amount_type.create!(name: 'Documentary Stamp Tax', amount: DocumentaryStampTax.set(loan), account: AccountingModule::Account.find_by(name: "Documentary Stamp Taxes"))
      loan.loan_charges.create!(charge: tax, commercial_document: loan)
    end

    # def set_loan_protection_fund
    #   LoansModule::LoanProtectionFund.set_loan_protection_fund_for(self)
    # end

    def create_amortization_schedule(loan)
      if loan.amortization_schedules.present?
        loan.amortization_schedules.destroy_all
      end
      LoansModule::AmortizationSchedule.create_schedule_for(loan)
    end

    # def set_borrower_full_name
    #   self.borrower_full_name = self.borrower.name
    #   self.save
    # end

    # def set_organization
    #   self.organization_id = self.borrower.organization_memberships.current.try(:organization_id)
    #   self.save
    # end

    # def set_barangay
    #   self.barangay_id = self.borrower.current_address.try(:barangay_id)
    #   self.save
    # end
  end
end
