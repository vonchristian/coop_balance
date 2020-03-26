class Merchant < ApplicationRecord
  has_many :utility_bills, as: :merchant
  has_many :clearing_house_depository_accounts, class_name: "ClearingHouseModule::ClearingHouseDepositoryAccount", as: :depositor 
  
  def depository_account_for(clearing_house:)
    clearing_house_depository_accounts.find_by!(clearing_house: clearing_house).depository_account
  end 
end
