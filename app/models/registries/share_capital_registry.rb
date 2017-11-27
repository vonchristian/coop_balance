module Registries
  class ShareCapitalRegistry < Registry

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
    private

    def create_or_find_member(row)
      Member.find_or_create_by(last_name: row[0], first_name: row[1])
    end

    def share_capital_product
      CoopServicesModule::ShareCapitalProduct.default_product
    end

    def find_member(row)
      Member.find_by(last_name: row[0], first_name: row[1])
    end

    def create_entry(row)
      share_capital = find_member(row).share_capitals.create!(share_capital_product: share_capital_product)

      share_capital.capital_build_ups.capital_build_up.create!(recorder_id: self.employee_id, description: 'Forwarded balance Share capital',  entry_date: Time.zone.now,
      debit_amounts_attributes: [account: debit_account, amount: row[2]],
      credit_amounts_attributes: [account: credit_account, amount: row[2]])
    end

    def debit_account
      AccountingModule::Account.find_by(name: "Cash on Hand (Treasury)")
    end

    def credit_account
      share_capital_product.paid_up_account
    end
  end
end
