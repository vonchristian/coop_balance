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

    validates :number_of_days, presence: true, numericality: true
    validates :loan_amount, presence: true, numericality: true

    validates :loan_product_id, :mode_of_payment, :application_date, :purpose, presence: true

    validate :maximum_term?

    def find_loan_application
      LoansModule::LoanApplication.find_by(account_number: account_number)
    end

    def process!
      return unless valid?

      ActiveRecord::Base.transaction do
        create_loan_application
        process_loan_application
      end
    end

    def find_loan_application
      LoansModule::LoanApplication.find_by(account_number: account_number)
    end

    private

    def create_loan_application
      loan_application = LoansModule::LoanApplication.new(
        cart: StoreFrontModule::Cart.create!(employee: find_preparer),
        cooperative: find_preparer.cooperative,
        office: find_preparer.office,
        organization: find_borrower.current_organization,
        purpose: purpose,
        borrower: find_borrower,
        loan_product_id: loan_product_id,
        loan_amount: loan_amount,
        application_date: application_date,
        mode_of_payment: mode_of_payment,
        preparer_id: preparer_id,
        account_number: account_number,
        term: number_of_days.to_i / 30,
        number_of_days: number_of_days
      )
      create_accounts(loan_application)
      loan_application.save!
    end

    def process_loan_application
      find_loan_product.loan_processor.new(loan_application: find_loan_application).process!
    end

    def create_accounts(loan_application)
      ::AccountCreators::LoanApplication.new(loan_application: loan_application).create_accounts!
    end

    def find_borrower
      borrower_type.constantize.find(borrower_id)
    end

    def find_preparer
      User.find(preparer_id)
    end

    def find_loan_product
      LoansModule::LoanProduct.find(loan_product_id)
    end

    def maximum_term?
      errors[:number_of_days] << "must not exceed 10 years." if number_of_days.to_f > 3650
    end
  end
end
