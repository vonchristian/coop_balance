class TimeDepositApplication < ApplicationRecord
  belongs_to :depositor, polymorphic: true
  belongs_to :time_deposit_product, class_name: "CoopServicesModule::TimeDepositProduct"
end
