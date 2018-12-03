require 'roo'
module Registries
  class ShareCapitalRegistry < Registry
    def parse_for_records
      share_capital_spreadsheet = Roo::Spreadsheet.open(spreadsheet.path)
      header = share_capital_spreadsheet.row(2)
      (3..share_capital_spreadsheet.last_row).each do |i|
        row = Hash[[header, share_capital_spreadsheet.row(i)].transpose]
        create_share_capital(row)
      end
    end

    private
    def find_cooperative
      self.employee.cooperative
    end
    def create_share_capital(row)
      cooperative = find_cooperative
      employee = self.employee
      office = self.employee.office
      subscriber = find_subscriber(row)
      share_capital_product = find_share_capital_product(row)
      credit_account = find_share_capital_product(row).paid_up_account
      debit_account = AccountingModule::Account.find_by(name: "Deposit in Transit")

      share_capital = cooperative.share_capitals.create!(
      subscriber: subscriber,
      account_number: SecureRandom.uuid,
      office: office,
      last_transaction_date: cut_off_date,
      share_capital_product: share_capital_product)

      cooperative.entries.create!(
        office: office,
        recorder: employee,
        previous_entry: cooperative.entries.recent,
        commercial_document: subscriber,
        description: "Forwarded balance of share capital as of #{cut_off_date.strftime("%B %e, %Y")}",
        entry_date: cut_off_date,
        debit_amounts_attributes: [
                account: debit_account,
                amount: row["Balance"].to_f,
                commercial_document: share_capital
                ],
        credit_amounts_attributes: [
                account: credit_account,
                amount: row["Balance"].to_f,
                commercial_document: share_capital
                ])
    end

    def cut_off_date
      Date.parse("#{Time.now.year}-09-30")
    end

    def find_share_capital_product(row)
      find_cooperative.share_capital_products.find_by(name: row["Share Capital Product"])
    end

    def find_subscriber(row)
      if row["Subscriber Type"] == "Member"
        find_cooperative.member_memberships.find_or_create_by(last_name: row["Last Name"], first_name: row["First Name"])
      elsif row["Subscriber Type"] == "Organization"
      find_cooperative.organizations.find_or_create_by(name: row["Last Name"])
      end
    end
  end
end
