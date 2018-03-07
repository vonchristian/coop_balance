module CoopServicesModule
	class TimeDepositProduct < ApplicationRecord
	  enum time_deposit_product_type: [:for_member, :for_non_member]
    has_one :break_contract_fee
    belongs_to :account, class_name: "AccountingModule::Account"
    delegate :name, to: :account, prefix: true
    validates :account_id, :name, :time_deposit_product_type, presence: true
    validates :name, uniqueness: true

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

    def self.set_product_for(time_deposit)
      if time_deposit.member?
       set_time_deposit_product_for_member(time_deposit)
      elsif time_deposit.non_member?
        set_time_deposit_product_for_non_member(time_deposit)
      end
    end

    def amount_range
      minimum_amount..maximum_amount
    end
    def amount_range_and_days
      "#{name} - #{amount_range} #{number_of_days} days"
    end

    private
    def self.set_time_deposit_product_for_member(time_deposit)
	    time_deposit_product = for_member.select{ |a| a.amount_range.include?(time_deposit.amount_deposited) }.first
	    if time_deposit_product.present?
	      time_deposit.time_deposit_product = time_deposit_product
	      time_deposit.save
	    end
	  end
     def self.set_time_deposit_product_for_non_member(time_deposit)
      time_deposit_product = for_non_member.select{ |a| a.amount_range.include?(time_deposit.amount_deposited) }.first
      if time_deposit_product.present?
        time_deposit.time_deposit_product = time_deposit_product
        time_deposit.save
      end
    end
	end
end
