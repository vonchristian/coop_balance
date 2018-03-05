module Registries
  class SavingsAccountRegistry < Registry
    def parse_for_records
      book = Spreadsheet.open(spreadsheet.path)
      sheet = book.worksheet(0)
      transaction do
        sheet.each 1 do |row|
          if !row[0].nil?
            create_entry(row)
          end
        end
      end
    end
    private
    def create_entry(row)
      savings = find_depositor(row).savings.create!(
        saving_product: find_saving_product(row),
        account_number: SecureRandom.uuid)
      savings.entries.create!(
      recorder_id: self.employee_id,
      description: 'Forwarded balance of savings deposit as of December 31, 2017',
      entry_date: Time.zone.now,
      debit_amounts_attributes: [account: debit_account, amount: row[2], commercial_document: savings],
      credit_amounts_attributes: [account: credit_account(row), amount: row[2], commercial_document: savings])
    end
    def find_saving_product(row)
      CoopServicesModule::SavingProduct.find_by(name: row[3])
    end

    def find_depositor(row)
      if row[4] == "Member"
        Member.find_or_create_by(last_name: row[0], first_name: row[1])
      elsif row[4] == "Organization"
        Organization.find_or_create_by(name: row[0])
      end
    end


    def debit_account
      AccountingModule::Account.find_by(name: "Cash on Hand - Main Office (Treasury)")
    end

    def credit_account(row)
      find_saving_product(row).account
    end
  end
end
