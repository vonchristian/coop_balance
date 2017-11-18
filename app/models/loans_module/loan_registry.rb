require 'spreadsheet'
module LoansModule
  class LoanRegistry < Registry
    def parse_for_records
      book = Spreadsheet.open(spreadsheet.path)
      sheet = book.worksheet(0)
      transaction do
        sheet.each 1 do |row|
          if !row[0].nil?
            create_or_find_member(row)
            create_or_find_loan(row)
            create_loan_balance_entry(row)
            create_loan_interests_entry(row)
            create_loan_penalties_entry(row)
          end
        end
      end
    end
    def create_or_find_member(row)
      Member.find_or_create_by(first_name: row[1], last_name: row[0])
    end

    def find_member(row)
      Member.find_by(first_name: row[0], last_name: row[1])
    end
    def find_loan_product(row)
      LoansModule::LoanProduct.find_or_create_by(name: row[2])
    end
    def create_or_find_loan(row)
      find_member(row).loans.create(loan_product: find_loan_product(row),
                               application_date: DateTime.parse(row[3].to_s),
                               loan_amount: row[5],
                               term: row[9].to_i,
                               mode_of_payment: normalize_mode_of_payment(row),
                               maturity_date: DateTime.parse(row[11].to_s)

                               )
    end

    def find_loan(row)
      find_member(row).loans.find_by(loan_product: find_loan_product(row),
                               application_date: DateTime.parse(row[3].to_s),
                               loan_amount: row[5],
                               term: row[9].to_i,
                               mode_of_payment: normalize_mode_of_payment(row),
                               maturity_date: DateTime.parse(row[11].to_s)

                               )
    end

    def normalize_mode_of_payment(row)
      if row[10].present?
        row[10].parameterize.gsub("-", "_")
      end
    end

    def create_loan_balance_entry(row)
      AccountingModule::Entry.create!(recorder_id: self.employee_id, description: 'Old loans upload', entry_date: Time.zone.now, commercial_document: find_loan(row),
        debit_amounts_attributes: [amount: row[6], account_id: AccountingModule::Account.find_by(name: 'Loans and Receivables').id],
        credit_amounts_attributes: [amount: row[6], account_id: AccountingModule::Account.find_by(name: 'Cash on Hand').id]
        )
    end
    def create_loan_interests_entry(row)
    end
    def create_loan_penalties_entry(row)
    end
  end
end
