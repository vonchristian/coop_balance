module ShareCapitals
  class Opening
    include ActiveModel::Model
    attr_reader :voucher, :share_capital_application, :employee, :subscriber, :cooperative
    def initialize(args)
      @voucher = args[:voucher]
      @share_capital_application = args[:share_capital_application]
      @employee = args[:employee]
      @cooperative = @employee.cooperative
      @subscriber = @share_capital_application.subscriber
    end

    def process!
      ActiveRecord::Base.transaction do
        create_share_capital
      end
    end

    def find_share_capital
      cooperative.share_capitals.find_by(account_number: share_capital_application.account_number)
    end

    private
    def create_share_capital
      share_capital = cooperative.share_capitals.create!(
        account_owner_name:    subscriber.name,
        cooperative:           employee.cooperative,
        subscriber:            subscriber,
        account_number:        share_capital_application.account_number,
        date_opened:           share_capital_application.date_opened,
        share_capital_product: share_capital_application.share_capital_product,
        last_transaction_date: share_capital_application.date_opened,
        beneficiaries:         share_capital_application.beneficiaries,
        office:                employee.office
      )
      update_voucher(share_capital)
    end

    def update_voucher(share_capital)
      voucher.voucher_amounts.each do |voucher_amount|
        voucher_amount.commercial_document = share_capital
        voucher_amount.save
      end
    end
  end

end
