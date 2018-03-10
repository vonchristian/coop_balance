module Registries
  class TimeDepositRegistry < Registry
    def parse_for_records
      book = Spreadsheet.open(spreadsheet.path)
      sheet = book.worksheet(0)
      transaction do
        sheet.each 1 do |row|
          if !row[0].nil?
            create_savings_account(row)
          end
        end
      end
    end

    private
    def create_time_deposit(row)
       time_deposit = MembershipsModule::TimeDeposit.create!(
          depositor: find_depositor(row),
          account_number: SecureRandom.uuid,
          date_deposited: date_deposited(row),
          time_deposit_product: find_time_deposit_product)
        TimeDepositsModule::FixedTerm.create!(
          time_deposit: time_deposit,
          number_of_days: number_of_days,
          deposit_date: date,
          maturity_date: (date.to_date + (number_of_days.to_i.days)))
        create_entry(time_deposit)
     end

    def create_entry(time_deposit, row)
      AccountingModule::Entry.create!(
      commercial_document: find_depositor(row),
      origin: self.employee.office,
      recorder: self.employee,
      description: 'Forwarded balance of time deposit as of December 31, 2017',
      entry_date: Date.today.last_year.end_of_year,
      debit_amounts_attributes: [
        account: debit_account,
        amount: row[2].to_f,
        commercial_document: savings],
      credit_amounts_attributes: [
        account: credit_account(row),
        amount: row[2].to_f,
        commercial_document: savings])
    end
    def find_saving_product(row)
      CoopServicesModule::SavingProduct.find_by(name: row[3])
    end

    def find_depositor(row)
      if row[4] == "Member"
        Member.find_or_create_by(last_name: row[0], first_name: row[1])
      elsif row[4] == "Organization"
        Organization.find_or_create_by(name: row[0])
      end
    end


    def debit_account
      AccountingModule::Account.find_by(name: "Cash on Hand")
    end

    def credit_account(row)
      find_saving_product(row).account
    end
  end
end
