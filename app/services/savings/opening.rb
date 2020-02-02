module Savings
  class Opening
    include ActiveModel::Model
    attr_reader :voucher, :savings_account_application, :employee, :office

    def initialize(args)
      @voucher                     = args[:voucher]
      @savings_account_application = args[:savings_account_application]
      @employee                    = args[:employee]
      @office                      = @employee.office
    end

    def open_account!
      ActiveRecord::Base.transaction do
        create_savings_account
      end
    end

    def find_savings_account
      employee.cooperative.savings.find_by(account_number: savings_account_application.account_number)
    end

    private
    def create_savings_account
      savings_account = office.savings.build(
        liability_account:     savings_account_application.liability_account,
        account_owner_name:    find_depositor.name,
        cooperative:           employee.cooperative,
        depositor:             find_depositor,
        account_number:        savings_account_application.account_number,
        date_opened:           savings_account_application.date_opened,
        saving_product:        savings_account_application.saving_product,
        beneficiaries:         savings_account_application.beneficiaries
      )
      create_accounts(savings_account)
      savings_account.save!
    end

    def create_accounts(savings_account)
      ::AccountCreators::Saving.new(saving: savings_account).create_accounts!
    end

    def find_depositor
      savings_account_application.depositor
    end
  end

end
