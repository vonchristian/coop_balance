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
      if row[4] == "Member"
        Member.find_or_create_by(last_name: row[0], first_name: row[1])
      elsif row[4] == "Organization"
        Organization.find_or_create_by(name: row[0])
      end
    end

    def create_entry(row)
      share_capital = MembershipsModule::ShareCapital.create(
        subscriber: find_subscriber(row),
        account_number: SecureRandom.uuid,
        share_capital_product: find_share_capital_product(row))
      AccountingModule::Entry.create!(
        origin: find_employee.office,
        recorder: find_employee,
        commercial_document: find_subscriber(row),
        description: 'Forwarded balance of share capital as of December 15, 2017',
        entry_date: Date.today.last_year.end_of_year - 16.days,
        debit_amounts_attributes: [account: debit_account, amount: row[2].to_f, commercial_document: share_capital],
        credit_amounts_attributes: [account: credit_account(row), amount: row[2].to_f, commercial_document: share_capital])
    end

    def debit_account
      AccountingModule::Account.find_by(name: "Cash on Hand")
    end

    def credit_account(row)
      find_share_capital_product(row).paid_up_account
    end
    def find_employee
      User.find_by_id(employee_id)
    end
  end
end
