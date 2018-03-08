module Registries
  class LoanRegistry < Registry
    def parse_for_records
      book = Spreadsheet.open(spreadsheet.path)
      sheet = book.worksheet(0)
      transaction do
        sheet.each 1 do |row|
          if !row[0].nil?
            upload_loan(row)
          end
        end
      end
    end

    private
    def upload_loan(row)
      if loan_amount(row).present? && due_date(row).present? && issued_date(row).present?
        loan = LoansModule::Loan.create!(
        borrower: find_borrower(row),
        loan_product: find_loan_product(row),
        barangay: find_barangay(row),
        loan_amount: loan_amount(row),
        term: term(row),
        application_date: issued_date(row),
        disbursement_date: issued_date(row)
          )
        #disbursement
        AccountingModule::Entry.create!(
        origin: self.employee.office,
        recorder: self.employee,
        commercial_document: loan.borrower,
        description: "Forwarded loan disbursement as of December 31, 2017",
        entry_date: Date.today.last_year.end_of_year,
        debit_amounts_attributes: [
          { amount: loan_amount(row),
            account: find_loan_product(row).loans_receivable_current_account,
            commercial_document: loan },
          { amount: payment_amount(row),
            account: cash_on_hand_account,
            commercial_document: loan }],
        credit_amounts_attributes: [
          { amount: loan_amount(row),
          account: cash_on_hand_account,
          commercial_document: loan },
          { amount: payment_amount(row),
          account: find_loan_product(row).loans_receivable_current_account,
          commercial_document: loan }
          ])
      end
    end

    def find_borrower(row)
      if row[8] == "Member"
        Member.find_or_create_by(last_name: row[0].downcase.titleize, first_name: row[1].try(:downcase).try(:titleize))
      elsif row[8] == "Organization"
        Organization.find_or_create_by(name: row[0].downcase.titleize)
      end
    end

    def find_loan_product(row)
      LoansModule::LoanProduct.find_by(name: row[2])
    end

    def find_barangay(row)
      Addresses::Barangay.find_or_create_by(name: row[7].to_s)
    end

    def loan_amount(row)
      row[3].to_f
    end

    def term(row)
      ((due_date(row).to_time - issued_date(row).to_time)/1.month.second)
    end

    def due_date(row)
      Chronic.parse(row[5])
    end

    def issued_date(row)
      Chronic.parse(row[4])
    end

    def cash_on_hand_account
      AccountingModule::Account.find_by(name: "Cash on Hand")
    end

    def payment_amount(row)
      loan_amount(row) - balance_amount(row)
    end

    def balance_amount(row)
      row[6]
    end
  end
end
