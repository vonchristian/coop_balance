module SavingsAccounts
  class BalanceTransferDestinationAccountProcessing
    include ActiveModel::Model
    attr_accessor :origin_saving_id, :destination_saving_id

    def find_destination_saving
      MembershipsModule::Saving.find(destination_saving_id)
    end
  end
end
