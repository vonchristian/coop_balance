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
          end
        end
      end
    end
    def create_or_find_member(row)
      Member.find_or_create_by(first_name: row[0], last_name: row[1])
    end

    def find_member(row)
      Member.find_by(first_name: row[0], last_name: row[1])
    end
    def find_loan_product(row)
      LoansModule::LoanProduct.find_or_create_by(name: row[2], interest_rate: 0.12)
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
    def normalize_mode_of_payment(row)
      if row[10].present?
        row[10].parameterize.gsub("-", "_")
      end
    end
  end
end