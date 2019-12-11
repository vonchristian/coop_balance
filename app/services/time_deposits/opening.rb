module TimeDeposits
  class Opening
    attr_reader :voucher, :time_deposit_application, :employee, :depositor

    def initialize(voucher:, time_deposit_application:, employee:)
      @voucher                  = voucher
      @time_deposit_application = time_deposit_application
      @employee                 = employee
      @depositor                = @time_deposit_application.depositor
    end

    def process!
      ActiveRecord::Base.transaction do
        create_time_deposit
      end
    end

    private
    def create_time_deposit
      time_deposit = depositor.time_deposits.build(
        depositor_name:       depositor.name,
        cooperative:          employee.cooperative,
        office:               employee.office,
        account_number:       time_deposit_application.account_number,
        date_deposited:       time_deposit_application.date_deposited,
        time_deposit_product: time_deposit_application.time_deposit_product,
        certificate_number:   set_certificate_number,
        beneficiaries:        time_deposit_application.beneficiaries,
        liability_account:    time_deposit_application.liability_account
      )
      create_term(time_deposit)
      create_accounts(time_deposit)
      time_deposit.save!
    end

    def create_term(time_deposit)
      time_deposit.create_term(
        term:             time_deposit_application.term,
        effectivity_date: voucher.date,
        maturity_date:    (voucher.date.to_date + (time_deposit_application.term.to_i.months))
      )
    end

    def create_accounts(time_deposit)
      ::AccountCreators::TimeDeposit.new(time_deposit: time_deposit).create_accounts!
    end

    def set_certificate_number
      TimeDeposits::CertificateNumberGenerator.new(time_deposit_application: time_deposit_application).generate!
    end
  end
end
