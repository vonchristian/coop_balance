module LoansModule
  module LoanApplications
    class VoucherProcessing
      include ActiveModel::Model
      attr_accessor :loan_application_id, :preparer_id, :date, :description,
                    :number, :reference_number, :account_number, :voucher_account_number, :cash_account_id, :borrower_id,
                    :borrower_type, :net_proceed

      validates :reference_number, :cash_account_id, :date, presence: true

      def process!
        return unless valid?

        ActiveRecord::Base.transaction do
          create_voucher
        end
      end

      def find_voucher
        TreasuryModule::Voucher.find_by(account_number: voucher_account_number)
      end

      private

      def create_voucher
        voucher = TreasuryModule::Voucher.new(
          account_number: voucher_account_number,
          payee_id: borrower_id,
          payee_type: borrower_type,
          preparer: find_employee,
          office: find_employee.office,
          cooperative: find_employee.cooperative,
          description: description,
          reference_number: reference_number,
          date: date
        )

        create_voucher_amounts(voucher)

        voucher.save!

        find_loan_application.update!(voucher: voucher)
      end

      def create_voucher_amounts(voucher)
        create_loan_charges(voucher)
        create_loans_receivable(voucher)
        create_net_proceed(voucher)
      end

      def create_loans_receivable(voucher)
        Vouchers::VoucherAmount.create!(
          cooperative: find_cooperative,
          voucher: voucher,
          amount_type: "debit",
          amount: find_loan_application.loan_amount,
          description: "Loan Amount",
          account: find_loan_application.receivable_account
        )
      end

      def create_net_proceed(voucher)
        Vouchers::VoucherAmount.create!(
          cooperative: find_cooperative,
          voucher: voucher,
          amount_type: "credit",
          amount: find_loan_application.net_proceed,
          description: "Net Proceed",
          account_id: cash_account_id
        )
      end

      def create_loan_charges(voucher)
        find_loan_application.voucher_amounts.each do |voucher_amount|
          Vouchers::VoucherAmount.create!(
            voucher: voucher,
            amount: voucher_amount.amount,
            cooperative: find_cooperative,
            amount_type: voucher_amount.amount_type,
            account: voucher_amount.account,
            description: voucher_amount.description
          )
        end
      end

      def find_loan_application
        find_cooperative.loan_applications.find(loan_application_id)
      end

      def find_cooperative
        find_employee.cooperative
      end

      def find_employee
        User.find(preparer_id)
      end
    end
  end
end
