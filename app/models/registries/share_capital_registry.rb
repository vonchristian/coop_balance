require 'roo'
module Registries
  class ShareCapitalRegistry < Registry

    def parse_for_records
      share_capital_spreadsheet = Roo::Spreadsheet.open(spreadsheet.path)
      header = share_capital_spreadsheet.row(2)
      (3..share_capital_spreadsheet.last_row).each do |i|
        row = Hash[[header, share_capital_spreadsheet.row(i)].transpose]
        create_entry(row)
      end
    end

    private
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

    def create_entry(row)
      share_capital = find_cooperative.share_capitals.create(
        subscriber: find_subscriber(row),
        account_number: SecureRandom.uuid,
        office: self.employee.office,
        last_transaction_date: cut_off_date,
        share_capital_product: find_share_capital_product(row))

      AccountingModule::Entry.create!(
        office: self.employee.office,
        cooperative: self.employee.cooperative,
        recorder: self.employee,
        commercial_document: find_subscriber(row),
        description: "Forwarded balance of share capital as of #{cut_off_date.strftime("%B %e, %Y")}",
        entry_date: cut_off_date,
        debit_amounts_attributes: [
                account: debit_account,
                amount: row["Balance"].to_f,
                commercial_document: share_capital
                ],
        credit_amounts_attributes: [
                account: credit_account(row),
                amount: row["Balance"].to_f,
                commercial_document: share_capital
                ])
    end

    def debit_account
      AccountingModule::Account.find_by(name: "Deposit in Transit")
    end

    def credit_account(row)
      find_share_capital_product(row).paid_up_account
    end

    def cut_off_date
      Date.parse("#{Time.now.year}-09-30")
    end

  end
end
