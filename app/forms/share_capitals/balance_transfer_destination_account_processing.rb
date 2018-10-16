module ShareCapitals
  class BalanceTransferDestinationAccountProcessing
    include ActiveModel::Model
    attr_accessor :destination_share_capital_id

    def find_destination_share_capital
      MembershipsModule::ShareCapital.find(destination_share_capital_id)
    end
  end
end
