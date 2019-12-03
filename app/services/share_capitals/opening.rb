module ShareCapitals
  class Opening
    attr_reader :voucher, :share_capital_application, :employee, :office

    def initialize(voucher:, share_capital_application:, employee:)
      @voucher                   = voucher
      @share_capital_application = share_capital_application
      @employee                  = employee
      @office                    = @employee.office

    end

    def process!
      ActiveRecord::Base.transaction do
        create_share_capital
      end
    end

    def find_share_capital
      office.share_capitals.find_by!(account_number: share_capital_application.account_number)
    end

    private

    def create_share_capital
      share_capital = office.share_capitals.build(
        account_owner_name:           share_capital_application.subscriber.name,
        cooperative:                  employee.cooperative,
        subscriber:                   share_capital_application.subscriber,
        account_number:               share_capital_application.account_number,
        date_opened:                  share_capital_application.date_opened,
        share_capital_product:        share_capital_application.share_capital_product,
        last_transaction_date:        share_capital_application.date_opened,
        beneficiaries:                share_capital_application.beneficiaries,
        share_capital_equity_account: share_capital_application.equity_account
      )
      create_accounts(share_capital)
      share_capital.save!
    end

    def create_accounts(share_capital)
      ::AccountCreators::ShareCapital.new(share_capital: share_capital).create_accounts!
    end
  end

end
