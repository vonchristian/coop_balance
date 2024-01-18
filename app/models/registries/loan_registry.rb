module Registries
  class LoanRegistry < Registry
    def parse_for_records
      loan_spreadsheet = Roo::Spreadsheet.open(spreadsheet.attachment.path)
      header = loan_spreadsheet.row(2)
      (3..loan_spreadsheet.last_row).each do |i|
        row = [header, loan_spreadsheet.row(i)].transpose.to_h
        upload_loan(row)
      end
    end

    private

    def upload_loan(row)
      loan = LoansModule::Loan.create!(
        forwarded_loan: true,
        cooperative: employee.cooperative,
        office: office,
        borrower: find_borrower(row),
        loan_product: find_loan_product(row),
        barangay: find_barangay(row),
        organization: find_organization(row),
        municipality: find_municipality(row),
        loan_amount: loan_amount(row),
        status: loan_status(row)
      )
      Term.create(
        term: term(row),
        termable: loan,
        effectivity_date: disbursement_date(row),
        maturity_date: maturity_date(row)
      )
      cooperative.entries.create!(
        office: employee.office,
        cooperative: employee.cooperative,
        recorder: employee,
        commercial_document: loan.borrower,
        description: "Forwarded loan balance as of #{cut_off_date(row).strftime('%B %e, %Y')}",
        entry_date: cut_off_date(row),
        debit_amounts_attributes: [
          amount: loan_balance(row),
          account: loan.principal_account,
          commercial_document: loan
        ],
        credit_amounts_attributes: [
          amount: loan_balance(row),
          account: credit_account,
          commercial_document: loan
        ]
      )
    end

    def find_borrower(row)
      if row['Borrower Type'] == 'Member'
        find_or_create_member_borrower(row)
      elsif row['Borrower Type'] == 'Organization'
        cooperative.organizations.find_or_create_by(name: row['Last Name'])
      end
    end

    def find_or_create_member_borrower(row)
      old_member = Member.find_by(last_name: row['Last Name'], first_name: row['First Name'], middle_name: row['Middle Name'])
      if old_member.present?
        old_member
      else
        new_member = Member.create(
          last_name: row['Last Name'],
          middle_name: row['Middle Name'],
          first_name: row['First Name']
        )

        new_member.memberships.create(cooperative: cooperative)
        new_member
      end
    end

    def find_loan_product(row)
      LoansModule::LoanProduct.find_by(name: row['Loan Product'])
    end

    def cut_off_date(row)
      Date.parse(row['Cut Off Date'].to_s)
    end

    def find_organization(row)
      cooperative.organizations.find_or_create_by(name: row['Organization'])
    end

    def find_barangay(row)
      Addresses::Barangay.find_or_create_by(name: row['Barangay'])
    end

    def find_municipality(row)
      Addresses::Municipality.find_or_create_by(name: row['Municipality'])
    end

    def loan_balance(row)
      row['Loan Balance'].to_d
    end

    def loan_amount(row)
      row['Loan Amount'].to_d
    end

    def term(row)
      ((maturity_date(row).year * 12) + maturity_date(row).month) - ((disbursement_date(row).year * 12) + disbursement_date(row).month)
    end

    def loan_status(row)
      row['Status'].parameterize.tr('-', '_')
    end

    def maturity_date(row)
      Date.parse(row['Maturity Date'].to_s)
    end

    def disbursement_date(row)
      Date.parse(row['Disbursement Date'].to_s)
    end

    def credit_account
      AccountingModule::Account.find_by(name: 'Temporary Loans Account')
    end
  end
end
