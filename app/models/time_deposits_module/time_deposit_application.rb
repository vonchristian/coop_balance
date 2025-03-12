module TimeDepositsModule
  class TimeDepositApplication < ApplicationRecord
    belongs_to :cooperative
    belongs_to :office,               class_name: "Cooperatives::Office"
    belongs_to :depositor,            polymorphic: true
    belongs_to :time_deposit_product, class_name: "CoopServicesModule::TimeDepositProduct"
    belongs_to :liability_account,    class_name: "AccountingModule::Account"

    validates :number_of_days, presence: true, numericality: { only_integer: true }
  end
end
