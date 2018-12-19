module TimeDeposits
  class Opening
    include ActiveModel::Model
    attr_reader :voucher, :time_deposit_application, :employee
    def initialize(args)
      @voucher = args[:voucher]
      @time_deposit_application = args[:time_deposit_application]
      @employee = args[:employee]
    end

    def process!
      ActiveRecord::Base.transaction do
        create_time_deposit
      end
    end

    private
    def create_time_deposit
      time_deposit = MembershipsModule::TimeDeposit.create!(
        depositor_name:       find_depositor.name,
        cooperative:          employee.cooperative,
        depositor:            find_depositor,
        account_number:       time_deposit_application.account_number,
        date_deposited:       time_deposit_application.date_deposited,
        time_deposit_product: time_deposit_application.time_deposit_product,
        certificate_number:   set_certificate_number,
        beneficiaries:        time_deposit_application.beneficiaries
      )
      Term.create!(
        termable:         time_deposit,
        term:             time_deposit_application.term,
        effectivity_date: voucher.date,
        maturity_date:    (voucher.date.to_date + (time_deposit_application.term.to_i.months))
      )
      
      update_voucher(time_deposit)
    end

    def find_depositor
      time_deposit_application.depositor
    end

    def entry_date
      voucher.accounting_entry.entry_date
    end

    def update_voucher(time_deposit)
      voucher.voucher_amounts.each do |voucher_amount|
        voucher_amount.commercial_document = time_deposit
        voucher_amount.save
      end
    end

    def set_certificate_number
      date_deposited = time_deposit_application.date_deposited
      datestamp = date_deposited.strftime("%Y%m%d")
      recent_time_deposits = employee.cooperative.time_deposits.where(date_deposited: date_deposited)
      datestamp.to_s << ("-0" + (recent_time_deposits.count+1).to_s)
    end
  end

end
