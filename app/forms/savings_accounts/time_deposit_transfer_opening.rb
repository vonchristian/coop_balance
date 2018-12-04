module SavingsAccounts
  class TImeDepositTransferOpening
    include ActiveModel::Model
    attr_reader :voucher, :time_deposit, :employee

    def initialize(args)
      @voucher      = args[:voucher]
      @time_deposit = args[:time_deposit]
      @employee     = args[:employee]
    end

    def process!
      ActiveRecord::Base.transaction do
        create_savings_account
      end
    end

    private
    def create_savings_account
      savings_account = MembershipsModule::Saving.create!(
        account_owner_name: find_depositor.full_name,
        cooperative: employee.cooperative,
        depositor: find_depositor,
        account_number: time_deposit.account_number,
        date_opened: voucher.date,
        saving_product: savings_account_application.saving_product,
        last_transaction_date: savings_account_application.date_opened
      )
      update_voucher(savings_account)
    end

    def find_depositor
      savings_account_application.depositor
    end

    def update_voucher(savings_account)
      voucher.voucher_amounts.each do |voucher_amount|
        voucher_amount.commercial_document = savings_account
        voucher_amount.save
      end
    end
  end

end
