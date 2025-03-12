require "roo"
module Registries
  class BankAccountRegistry < Registry
    def parse_for_records
      bank_spreadsheet = Roo::Spreadsheet.open(spreadsheet.path)
      header = bank_spreadsheet.row(2)
      (3..bank_spreadsheet.last_row).each do |i|
        row = [ header, bank_spreadsheet.row(i) ].transpose.to_h
        upload_bank_accounts(row)
      end
    end

    def upload_bank_accounts(row)
      return if row["Balance"].to_f.zero? || row["Balance"].nil?

      bank_account = find_cooperative.bank_accounts.create!(
        bank_name: bank_name(row),
        bank_address: row["Bank Address"],
        office: employee.office,
        cash_account: cash_account(row),
        interest_revenue_account: interest_revenue_account(row),
        last_transaction_date: cut_off_date,
        account_number: row["Bank Account Number"]
      )
      create_entry(bank_account, row)
    end

    def create_entry(bank_account, row)
      find_cooperative.entries.create!(
        commercial_document: bank_account,
        office: employee.office,
        cooperative: find_cooperative,
        recorder: employee,
        description: "Forwarded balance of #{bank_name(row)} as of #{cut_off_date.strftime('%B %e, %Y')}",
        entry_date: cut_off_date,
        debit_amounts_attributes: [
          account: cash_account(row),
          amount: row["Balance"].to_f,
          commercial_document: bank_account
        ],
        credit_amounts_attributes: [
          account: debit_account,
          amount: row["Balance"].to_f,
          commercial_document: bank_account
        ]
      )
    end

    def find_cooperative
      employee.cooperative
    end

    def bank_name(row)
      row["Bank Name"]
    end

    def account_number(row)
      row["Bank Account Number"]
    end

    def cash_account(row)
      find_cooperative.accounts.asset.find_by(name: row["Cash Account"])
    end

    def interest_revenue_account(row)
      find_cooperative.accounts.asset.find_by(name: row["Interest Revenue Account"])
    end

    def cut_off_date
      Chronic.parse("09/30/2018")
    end

    def debit_account
      find_cooperative.accounts.find_by(name: "Temporary Bank Account")
    end
  end
end
