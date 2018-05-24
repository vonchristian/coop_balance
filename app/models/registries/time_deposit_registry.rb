module Registries
  class TimeDepositRegistry < Registry
    def parse_for_records
      book = Spreadsheet.open(spreadsheet.path)
      sheet = book.worksheet(0)
      transaction do
        sheet.each 1 do |row|
          if !row[0].nil?
            create_time_deposit(row)
          end
        end
      end
    end
    private
    def create_time_deposit(row)
      time_deposit = MembershipsModule::TimeDeposit.create!(
      depositor:            find_depositor(row),
      account_number:       SecureRandom.uuid,
      time_deposit_product: find_time_deposit_product(row))
      time_deposit.terms.create!(
      term:             term(row),
      effectivity_date: DateTime.parse(row[6].to_s),
      maturity_date:    DateTime.parse(row[7].to_s))
      create_entry(time_deposit, row)
     end

    def create_entry(time_deposit, row)
      AccountingModule::Entry.create!(
      commercial_document: find_depositor(row),
      origin: self.employee.office,
      recorder: self.employee,
      description: "Time deposit on #{DateTime.parse(row[6].to_s).strftime("%B %e, %Y")}",
      entry_date: Date.today.last_year.end_of_year,
      debit_amounts_attributes: [
        account: debit_account,
        amount: row[2].to_f,
        commercial_document: time_deposit],
      credit_amounts_attributes: [
        account: credit_account(row),
        amount: row[2].to_f,
        commercial_document: time_deposit])
    end
    def find_time_deposit_product(row)
      CoopServicesModule::TimeDepositProduct.find_by(name: row[3])
    end

    def find_depositor(row)
      if row[4] == "Member"
        Member.find_or_create_by(last_name: row[0], first_name: row[1])
      elsif row[4] == "Organization"
        Organization.find_or_create_by(name: row[0])
      end
    end
    def term(row)
      row[5]
    end

    def debit_account
      AccountingModule::Account.find_by(name: "Cash on Hand")
    end

    def credit_account(row)
      find_time_deposit_product(row).account
    end
  end
end
