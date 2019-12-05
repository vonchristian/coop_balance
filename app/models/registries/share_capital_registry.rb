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
      credit_account = find_share_capital_product(row).equity_account
      debit_account = AccountingModule::Account.find_by(name: "Temporary Share Capital Account")

      share_capital = cooperative.share_capitals.create!(
      subscriber: subscriber,
      account_number: SecureRandom.uuid,
      office: office,
      last_transaction_date: cut_off_date(row),
      share_capital_product: share_capital_product)

      cooperative.entries.create!(
        office: office,
        recorder: employee,
        commercial_document: subscriber,
        description: "Forwarded balance of share capital as of #{cut_off_date(row).strftime("%B %e, %Y")}",
        entry_date: cut_off_date(row),
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

    def cut_off_date(row)
      Date.parse(row["Cut Off Date"].to_s)
    end

    def find_share_capital_product(row)
      find_cooperative.share_capital_products.find_by(name: row["Share Capital Product"])
    end

    def find_subscriber(row)
      if row["Subscriber Type"] == "Member"
        find_or_create_member_subscriber(row)
      elsif row["Subscriber Type"] == "Organization"
      find_cooperative.organizations.find_or_create_by(name: row["Last Name"])
      end
    end

    def find_or_create_member_subscriber(row)
      old_member = Member.find_by(last_name: row["Last Name"], first_name: row["First Name"], middle_name: row["Middle Name"])
      if old_member.present?
        old_member
      else
        new_member = Member.create(
          last_name: row["Last Name"],
          middle_name: row["Middle Name"],
          first_name: row["First Name"]
        )

        new_member.memberships.create!(cooperative: find_cooperative, account_number: SecureRandom.uuid)
        new_member
      end
    end
  end
end
