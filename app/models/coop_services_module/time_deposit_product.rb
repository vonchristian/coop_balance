module CoopServicesModule
	class TimeDepositProduct < ApplicationRecord
	  enum time_deposit_product_type: [:for_member, :for_non_member]
    belongs_to :account, class_name: "AccountingModule::Account"
    belongs_to :interest_expense_account, class_name: "AccountingModule::Account"
    belongs_to :break_contract_account, class_name: "AccountingModule::Account"

    delegate :name, to: :account, prefix: true
    validates :account_id,
              :interest_expense_account_id,
              :break_contract_account_id,
              :name,
              :minimum_deposit,
              :maximum_deposit,
              :annual_interest_rate,
              :break_contract_fee,
              :break_contract_rate,
              :time_deposit_product_type,
              presence: true
    validates :break_contract_fee,
              :break_contract_rate,
              :minimum_deposit,
              :maximum_deposit,
              :annual_interest_rate,
              numericality: true
    validates :name,
              :account_id,
              uniqueness: true


    def amount_range
      minimum_deposit..maximum_deposit
    end

    def amount_range_and_days
      "#{name} - #{amount_range} #{number_of_days} days"
    end

    def monthly_interest_rate
      rate = annual_interest_rate || 0.02
      rate / 12.0
    end

    private
   #  def self.set_time_deposit_product_for_member(time_deposit)
	  #   time_deposit_product = for_member.select{ |a| a.amount_range.include?(time_deposit.amount_deposited) }.first
	  #   if time_deposit_product.present?
	  #     time_deposit.time_deposit_product = time_deposit_product
	  #     time_deposit.save
	  #   end
	  # end
   #   def self.set_time_deposit_product_for_non_member(time_deposit)
   #    time_deposit_product = for_non_member.select{ |a| a.amount_range.include?(time_deposit.amount_deposited) }.first
   #    if time_deposit_product.present?
   #      time_deposit.time_deposit_product = time_deposit_product
   #      time_deposit.save
   #    end
   #  end
	end
end
