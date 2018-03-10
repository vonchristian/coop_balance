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
              :break_contract_fee,
              :time_deposit_product_type,
              presence: true
    validates :break_contract_fee,
              :minimum_deposit,
              :maximum_deposit,
              numericality: true
    validates :name,
              :account_id,
              uniqueness: true


    def self.accounts
      all.map{|a| a.account }
    end

    def self.accounts_balance(options={})
      accounts.uniq.map{|a| a.balance(options)}.sum
    end

    def self.accounts_credits_balance(options={})
      accounts.uniq.map{|a| a.credits_balance(options)}.sum
    end

    def self.accounts_debits_balance(options={})
      accounts.uniq.map{|a| a.debits_balance(options)}.sum
    end

    def amount_range
      minimum_deposit..maximum_deposit
    end
    def amount_range_and_days
      "#{name} - #{amount_range} #{number_of_days} days"
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
