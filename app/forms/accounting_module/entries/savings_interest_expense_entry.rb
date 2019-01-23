module AccountingModule
  class SavingsInterestExpenseEntry
    include ActiveModel::Model

    attr_accessor :date, :reference_number, :cooperative_id

    def process!
      create_savings_interest_expense_entry
    end

    private
    def create_savings_interest_expense_entry
      find_cooperative.savings.has_minimum_balance.each do |saving|
        create_entry(saving)
      end
    end

    def create_entry(saving)
      entry = AccountingModule::Entry.new(
        entry_date: date,
        recorder: find_employee,
        office: find_employee.office,
        cooperative: find_employee.cooperative,
        description: 'Interest expense on savings deposits',
        commercial_document: saving,
        reference_number: reference_number,
        previous_entry: find_cooperative.entries.recent,
        previous_entry_hash: find_cooperative.entries.recent.encrypted_hash
      )
      entry.debit_amounts.build(
        amount: amount_computation(saving.balance(to_date: date)),
        account: interest_expense_account,
        commercial_document: saving
      )
      entry.credit_amounts.build(
        amount: saving_product.compute_interest(saving.balance(to_date: date)),
        account: saving_product.account,
        commercial_document: saving
      )
      entry.save!
    end
  end
end
