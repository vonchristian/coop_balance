module LoansModule
  class LoanApplicationProcessing
    include ActiveModel::Model
    attr_accessor :borrower_id,
                  :borrower_type,
                  :number_of_days,
                  :purpose,
                  :loan_product_id,
                  :loan_amount,
                  :application_date,
                  :mode_of_payment,
                  :account_number,
                  :preparer_id,
                  :cooperative_id,
                  :office_id
    validates :number_of_days,  presence: true, numericality: true
    validates :loan_amount, presence: true
    validates :loan_product_id, :mode_of_payment, :number_of_days, :application_date, :purpose, presence: true
    validate :maximum_term?

    def find_loan_application
      LoansModule::LoanApplication.find_by(account_number: account_number)
    end
    def process!
      if valid?
        ActiveRecord::Base.transaction do
          create_loan_application
        end
      end
    end

    def find_loan
      LoansModule::LoanApplication.find_by(account_number: account_number)
    end

    private

    def create_loan_application
      loan_application = LoansModule::LoanApplication.new(
        cooperative:      find_preparer.cooperative,
        office:           find_preparer.office,
        organization:     find_borrower.current_organization,
        purpose:          purpose,
        borrower:         find_borrower,
        loan_product_id:  loan_product_id,
        loan_amount:      loan_amount,
        application_date: application_date,
        mode_of_payment:  mode_of_payment,
        preparer_id:      preparer_id,
        account_number:   account_number,
        term:             number_of_days.to_i/30,
        number_of_days:   number_of_days)
        create_accounts(loan_application)
        loan_application.save!

        find_loan_product.loan_processor.new(loan_application: loan_application).process!
    end

    def create_accounts(loan_application)
      ::AccountCreators::LoanApplication.new(loan_application: loan_application).create_accounts!
    end
    def find_borrower
      Borrower.find(borrower_id)
    end
    def find_preparer
      User.find(preparer_id)
    end
    
    def find_loan_product
      LoansModule::LoanProduct.find(loan_product_id)
    end

    def maximum_term?
      errors[:number_of_days] << "must not exceed 3600 delayed_jobs_priority." if number_of_days.to_f > 3600
    end
  end
end
