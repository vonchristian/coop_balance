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
        loan = find_cooperative.loans.create!(
          forwarded_loan: true,
          status: 'current_loan',
          cooperative: self.employee.cooperative,
          office: self.employee.office,
          borrower: find_borrower(row),
          loan_product: find_loan_product(row),
          barangay: find_barangay(row),
          organization: find_organization(row),
          municipality: find_municipality(row),
          loan_amount: loan_amount(row)
        )
        if disbursement_date(row).present? && term(row).present?

        Term.create(
          term: term(row),
          termable: loan,
          effectivity_date: disbursement_date(row),
          maturity_date: maturity_date(row)
        )
      end
        find_cooperative.entries.create!(
        office: self.employee.office,
        cooperative: self.employee.cooperative,
        recorder: self.employee,
        commercial_document: loan.borrower,
        previous_entry: find_cooperative.entries.recent,
        description: "Forwarded loan balance as of #{cut_off_date.strftime('%B %e, %Y')}",
        entry_date: cut_off_date,
        debit_amounts_attributes: [
          amount: loan_balance(row),
          account: find_loan_product(row).loans_receivable_current_account,
          commercial_document: loan ],
        credit_amounts_attributes: [
          amount: loan_balance(row),
          account: credit_account,
          commercial_document: loan
          ]
        )
    end

    def find_borrower(row)
      if row["Borrower Type"] == "Member"
        find_cooperative.member_memberships.find_or_create_by(last_name: row["Last Name"], first_name: row["First Name"], middle_name: row["Middle Name"])
      elsif row["Borrower Type"] == "Organization"
        find_cooperative.organizations.find_or_create_by(name: row["Last Name"])
      end
    end
    def find_cooperative
      self.employee.cooperative
    end

    def find_loan_product(row)
      find_cooperative.loan_products.find_by(name: row["Loan Product"])
    end

    def cut_off_date
      Date.parse('2018-09-30')
    end

    def find_organization(row)
      find_cooperative.organizations.find_or_create_by(name: row["Organization"])
    end

    def find_barangay(row)
      Addresses::Barangay.find_or_create_by(name: row["Barangay"])
    end

    def find_municipality(row)
      Addresses::Municipality.find_or_create_by(name: row["Municipality"])
    end

    def loan_balance(row)
      row["Balance"].to_f
    end

    def loan_amount(row)
      row["Loan Amount"].to_f
    end

    def term(row)
      row["Term"].to_i
    end

    def maturity_date(row)
      if disbursement_date(row).present? && term(row).present?
        disbursement_date(row) + term(row).to_i.months
      end
    end

    def disbursement_date(row)
      if row["Disbursement Date"].present?
        Date.parse(row["Disbursement Date"].to_s)
      end
    end

    def credit_account
      AccountingModule::Account.find_by(name: "Deposit in Transit")
    end
  end
end
