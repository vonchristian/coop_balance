module Registries
  class ShareCapitalRegistry < Registry

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
    def find_share_capital_product(row)
      CoopServicesModule::ShareCapitalProduct.find_by(name: row[3])
    end

    def find_subscriber(row)
      Member.find_or_create_by(last_name: row[0], first_name: row[1])
    end

    def create_entry(row)
      share_capital = MembershipsModule::ShareCapital.create(
        subscriber: find_subscriber(row),
        account_number: SecureRandom.uuid,
        share_capital_product: find_share_capital_product(row))
      AccountingModule::Entry.create!(
        recorder_id: self.employee_id,
        commercial_document: find_subscriber(row),
        description: 'Forwarded balance of share capital as of December 31, 2017',
        entry_date: Date.today.last_year.end_of_year,
        debit_amounts_attributes: [account: debit_account, amount: row[2].to_f, commercial_document: share_capital],
        credit_amounts_attributes: [account: credit_account(row), amount: row[2].to_f, commercial_document: share_capital])
    end

    def debit_account
      AccountingModule::Account.find_by(name: "Cash on Hand - Main Office (Treasury)")
    end

    def credit_account(row)
      find_share_capital_product(row).paid_up_account
    end
  end
end
