module TimeDepositsModule
  class InterestEarnedPosting
    def self.post_for(time_deposit)
      if time_deposit.matured?
        time_deposit.entries.time_deposit_interest.create
      AccountingModule::Entry.time_deposit_interest.create!(commercial_document: self, description: 'Time deposit earned interest', entry_date: Time.zone.now,
        debit_amounts_attributes: [account_id: AccountingModule::Account.find_by(name: "Interest Expense on Deposits").id, amount: self.balance * (self.time_deposit_product_interest_rate / 100.0) ],
        credit_amounts_attributes: [account_id: AccountingModule::Account.find_by(name: "Time Deposits").id, amount: self.balance * (self.time_deposit_product_interest_rate / 100.0) ])
      end
    end
    def self.interest_amount(time_deposit)
      time_deposit.balance * time_deposit.time_deposit_product_interest_rate / 100.0
    end
  end
end
