module Registries
  class TimeDepositRegistry < Registry

    def parse_for_records
      time_deposits_spreadsheet = Roo::Spreadsheet.open(spreadsheet.path)
      header = time_deposits_spreadsheet.row(2)
      (3..time_deposits_spreadsheet.last_row).each do |i|
        row = Hash[[header, time_deposits_spreadsheet.row(i)].transpose]
        create_time_deposit(row)
      end
    end

    private
    def create_time_deposit(row)
      time_deposit = self.employee.cooperative.time_deposits.create!(
        depositor:            find_depositor(row),
        office: self.office,
        account_number:       SecureRandom.uuid,
        time_deposit_product: find_time_deposit_product(row)
      )

      time_deposit.terms.create!(
        term:             term(row),
        effectivity_date: effectivity_date(row),
        maturity_date:    maturity_date(row)
      )

      create_entry(time_deposit, row)
     end

    def create_entry(time_deposit, row)
      AccountingModule::Entry.create!(
      office: self.employee.office,
      cooperative: self.employee.cooperative,
      commercial_document: find_depositor(row),
      recorder: self.employee,
      previous_entry: self.employee.cooperative.entries.recent,
      description: "Forwarded time deposit as of #{cut_off_date.strftime("%B %e, %Y")}",
      entry_date: cut_off_date,
      debit_amounts_attributes: [
        account: debit_account,
        amount: amount(row),
        commercial_document: time_deposit],
      credit_amounts_attributes: [
        account: credit_account(row),
        amount: amount(row),
        commercial_document: time_deposit])
    end

    def find_time_deposit_product(row)
      CoopServicesModule::TimeDepositProduct.find_by(name: row["Time Deposit Product"])
    end

    def find_depositor(row)
      if row["Depositor Type"] == "Member"
        Member.find_or_create_by(last_name: row["Last Name"], first_name: row["First Name"])
      elsif row["Depositor Type"] == "Organization"
        Organization.find_or_create_by(name: row["Last Name"])
      end
    end
    def term(row)
      row["Term"]
    end

    def amount(row)
      row["Amount"].to_f
    end

    def debit_account
      AccountingModule::Account.find_by(name: "Temporary Time Deposit Account")
    end

    def credit_account(row)
      find_time_deposit_product(row).account
    end

    def cut_off_date
      Date.parse('2018-09-30')
    end

    def effectivity_date(row)
      DateTime.parse(row["Date Deposited"].to_s)
    end

    def maturity_date(row)
      DateTime.parse(row["Maturity Date"].to_s)
    end
  end
end
