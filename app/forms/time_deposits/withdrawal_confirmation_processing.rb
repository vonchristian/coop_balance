module TimeDeposits
  class WithdrawalConfirmationProcessing
    include ActiveModel::Model
    attr_reader :time_deposit
    def initialize(args)
      @time_deposit = args[:time_deposit]
    end

    def process!
      ActiveRecord::Base.transaction do
        set_time_deposit_as_withdrawn
      end
    end

    def set_time_deposit_as_withdrawn
      find_time_deposit.update(withdrawn: true)
    end

    def find_time_deposit
      DepositsModule::TimeDeposit.find_by_id(time_deposit.id)
    end
  end
end
