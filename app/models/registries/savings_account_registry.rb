require 'roo'
module Registries
  class SavingsAccountRegistry < Registry
    def parse_for_records
      savings_spreadsheet = Roo::Spreadsheet.open(spreadsheet.path)
      header = savings_spreadsheet.row(2)
      (3..savings_spreadsheet.last_row).each do |i|
        row = Hash[[header, savings_spreadsheet.row(i)].transpose]
        upload_savings(row)
      end
    end
    def upload_savings(row)
       savings = MembershipsModule::Saving.create!(
        depositor: find_depositor(row),
        saving_product: find_saving_product(row),
        last_transaction_date: cut_off_date,
        account_number: SecureRandom.uuid)
       create_entry(savings, row)
    end
    def create_entry(savings, row)
      AccountingModule::Entry.create!(
      commercial_document: find_depositor(row),
      office: self.employee.office,
      cooperative: self.employee.office,
      recorder: self.employee,
      description: "Forwarded balance of savings deposit as of #{cut_off_date}",
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

    def find_depositor(row)
      # if row["Depositor Type"] == "Member"
      if row["First Name"].present?
        Member.find_or_create_by(last_name: row["Last Name"], first_name: row["First Name"])
      # elsif row["Depositor Type"] == "Organization"
      else
        Organization.find_or_create_by(name: row["Last Name"])
      end
    end


    def debit_account
      AccountingModule::Account.find_by(name: "Cash on Hand")
    end

    def credit_account(row)
      find_saving_product(row).account
    end
    def cut_off_date
      Chronic.parse('09/30/2018')
    end
  end
end
