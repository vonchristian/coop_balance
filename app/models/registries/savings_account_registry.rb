require 'roo'
module Registries
  class SavingsAccountRegistry < Registry
    def parse_for_records
      savings_spreadsheet = Roo::Spreadsheet.open(spreadsheet.path)
      header = savings_spreadsheet.row(2)
      (3..savings_spreadsheet.last_row).each do |i|
        row = Hash[[header, savings_spreadsheet.row(i)].transpose]
        depositor = find_depositor(row)
        upload_savings(depositor, row)
      end
    end
    def upload_savings(depositor, row)
      unless row["Balance"].to_f.zero? || row["Balance"].nil?
        savings = find_cooperative.savings.create!(
        depositor: depositor,
        office: self.employee.office,
        saving_product: find_saving_product(row),
        last_transaction_date: cut_off_date,
        account_number: SecureRandom.uuid)
        create_entry(depositor, savings, row)
      end
    end
    def create_entry(depositor, savings, row)
      AccountingModule::Entry.create!(
        commercial_document: depositor,
        office: self.employee.office,
        cooperative: find_cooperative,
        recorder: self.employee,
        previous_entry: find_cooperative.entries.recent,
        description: "Forwarded balance of savings deposit as of #{cut_off_date.strftime('%B %e, %Y')}",
        entry_date: cut_off_date,
        debit_amounts_attributes: [
          account: debit_account,
          amount: row["Balance"].to_f,
          commercial_document: savings],
        credit_amounts_attributes: [
          account: credit_account(row),
          amount: row["Balance"].to_f,
          commercial_document: savings])
    end

    def find_saving_product(row)
      CoopServicesModule::SavingProduct.find_by(name: row["Saving Product"])
    end

    def find_cooperative
      self.employee.cooperative
    end

    def find_depositor(row)
      if row["Depositor Type"] == "Member"
        find_cooperative.member_memberships.find_or_create_by(last_name: row["Last Name"], first_name: row["First Name"])
      elsif row["Depositor Type"] == "Organization"
        find_cooperative.organizations.find_or_create_by(name: row["Last Name"])
      end
    end

    def debit_account
      AccountingModule::Account.find_by(name: "Deposit in Transit")
    end

    def credit_account(row)
      find_saving_product(row).account
    end

    def cut_off_date
      Chronic.parse('09/30/2018')
    end
  end
end
