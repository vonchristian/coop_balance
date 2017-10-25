class BreakContractFee < ApplicationRecord
  belongs_to :time_deposit_product, class_name: "CoopServicesModule::TimeDepositProduct"
end
