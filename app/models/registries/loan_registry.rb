require 'roo'
module Registries
  class LoanRegistry < Registry
    def parse_for_records
      loan_spreadsheet = Roo::Spreadsheet.open(spreadsheet.path)
      header = loan_spreadsheet.row(2)
      (3..loan_spreadsheet.last_row).each do |i|
        row = Hash[[header, loan_spreadsheet.row(i)].transpose]
        upload_loan(row)
      end
    end

    private
    def upload_loan(row)
      if loan_amount(row).present? && term(row).present? && disbursement_date(row).present?
        loan = LoansModule::Loan.create!(
                  forwarded_loan: true,
                  cooperative: self.employee.cooperative,
                  office: self.employee.office,
                  borrower: find_borrower(row),
                  loan_product: find_loan_product(row),
                  barangay: find_barangay(row),
                  organization: find_organization(row),
                  loan_amount: loan_amount(row),
                  disbursement_date: disbursement_date(row)
              )
        Term.create(
          term: term(row),
          termable: loan,
          effectivity_date: disbursement_date(row),
          maturity_date: maturity_date(row)
          )
        #disbursement
        AccountingModule::Entry.create!(
        office: self.employee.office,
        cooperative: self.employee.cooperative,
        recorder: self.employee,
        commercial_document: loan.borrower,
        description: "Forwarded loan disbursement as of #{cut_off_date(row)}",
        entry_date: cut_off_date(row),
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
      if row["Borrower Type"] == "Member"
        Member.find_or_create_by(last_name: row["Last Name"], first_name: row["First Name"])
      elsif row["Borrower Type"] == "Organization"
        Organization.find_or_create_by(name: row["Last Name"])
      end
    end

    def find_loan_product(row)
      LoansModule::LoanProduct.find_by(name: row["Loan Product"])
    end

    def cut_off_date(row)
      Chronic.parse('09/30/2018')
    end

    def find_organization(row)
      Organization.find_or_create_by(name: row["Organization"])
    end

    def find_barangay(row)
      Addresses::Barangay.find_or_create_by(name: row[7].to_s)
    end

    def loan_amount(row)
      row["Loan Amount"].to_f
    end

    def term(row)
      row["Term"].to_i
    end

    def maturity_date(row)
      disbursement_date(row) + term(row).months
    end

    def disbursement_date(row)
      Date.parse(row["Disbursement Date"].to_s)
    end

    def cash_on_hand_account
      AccountingModule::Account.find_by(name: "Cash on Hand")
    end

    def payment_amount(row)
      loan_amount(row) - balance_amount(row)
    end

    def balance_amount(row)
      row['Balance'].to_f
    end
  end
end
