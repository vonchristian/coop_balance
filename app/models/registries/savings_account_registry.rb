module Registries
  class SavingsAccountRegistry < Registry
    def parse_for_records
      book = Spreadsheet.open(spreadsheet.path)
      sheet = book.worksheet(0)
      transaction do
        sheet.each 1 do |row|
          if !row[0].nil?
            create_or_find_member(row)
            create_entry(row)
          end
        end
      end
    end
    def account_number
      Membership.generate_account_number
    end

    def create_or_find_member(row)
      Member.find_or_create_by(last_name: row[0], first_name: row[1])
    end

    def find_saving_product(row)
      CoopServicesModule::SavingProduct.find_by(name: row[4])
    end
    def find_member(row)
      Member.find_by(last_name: row[0], first_name: row[1])
    end
    def create_savings(row)

    end
    def find_savings(row)
      MembershipsModule::Saving.find_by(account_number: account_number)
    end
    def create_entry(row)
      savings = find_member(row).savings.create(account_number: account_number,  saving_product: find_saving_product(row))
      savings.entries.create!(entry_type: 'deposit',  description: 'Savings deposit',  entry_date: Time.zone.now,
      debit_amounts_attributes: [account: debit_account, amount: row[2]],
      credit_amounts_attributes: [account: credit_account, amount: row[2]])
    end

    def debit_account
      AccountingModule::Account.find_by(name: "Cash on Hand (Treasury)")
    end

    def credit_account
      CoopConfigurationsModule::SavingsAccountConfig.default_account
    end
  end
end
