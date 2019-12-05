require 'roo'
module Registries
  class ProgramSubscriptionRegistry < Registry
    def parse_for_records
      program_spreadsheet = Roo::Spreadsheet.open(spreadsheet.path)
      header = program_spreadsheet.row(2)
      (3..program_spreadsheet.last_row).each do |i|
        row = Hash[[header, program_spreadsheet.row(i)].transpose]
        upload_program_subscription(row)
      end
    end

    def upload_program_subscription(row)
      program_subscription = find_or_create_member_subscriber(row).program_subscriptions.
      find_or_create_by(program: find_program(row))
      create_entry(row, program_subscription)

    end

    def find_program(row)
      self.employee.cooperative.programs.find_by(name: row["Program"])
    end

    def find_or_create_member_subscriber(row)
      old_member = Member.find_by(
        last_name:   TextNormalizer.new(text: row["Last Name"]).propercase,
        first_name:  TextNormalizer.new(text: row["First Name"] || "").propercase,
        middle_name: TextNormalizer.new(text: row["Middle Name"] || "").propercase
      )
      if old_member.present?
        old_member
      else
        new_member = Member.create!(
          last_name:   TextNormalizer.new(text: row["Last Name"]).propercase,
          middle_name: TextNormalizer.new(text: row["Middle Name"] || "").propercase,
          first_name:  TextNormalizer.new(text: row["First Name"] || "").propercase
        )
        new_member.memberships.create!(cooperative: self.employee.cooperative, account_number: SecureRandom.uuid)
        new_member
      end
    end

    def create_entry(row, program_subscription)
      AccountingModule::Entry.create!(
      commercial_document: find_or_create_member_subscriber(row),
      office: self.office,
      cooperative: self.employee.cooperative,
      recorder: self.employee,
      description: "Forwarded balance of as of #{cut_off_date(row).strftime('%B %e, %Y')}",
      entry_date: cut_off_date(row),
      debit_amounts_attributes: [
        account: debit_account,
        amount: row["Balance"].to_f,
        commercial_document: program_subscription],
      credit_amounts_attributes: [
        account: credit_account(row),
        amount: row["Balance"].to_f,
        commercial_document: program_subscription])
    end

    def debit_account
      AccountingModule::Account.find_by(name: "Temporary Program Subscription Account")
    end

    def credit_account(row)
      find_program(row).account
    end

    def cut_off_date(row)
      Date.parse(row["Cut Off Date"].to_s)
    end
  end
end
