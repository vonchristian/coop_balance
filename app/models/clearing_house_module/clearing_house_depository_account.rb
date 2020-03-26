module ClearingHouseModule 
  class ClearingHouseDepositoryAccount < ApplicationRecord
    belongs_to :depositor,         polymorphic: true
    belongs_to :clearing_house,     class_name: "AutomatedClearingHouse"
    belongs_to :depository_account, class_name: "AccountingModule::Account"
  end
end 