require 'roo'
module Registries
  class MemberRegistry < Registry
    def parse_for_records
      member_spreadsheet = Roo::Spreadsheet.open(spreadsheet.path)
      header = member_spreadsheet.row(1)
      (2..member_spreadsheet.last_row).each do |i|
        row = Hash[[header, member_spreadsheet.row(i)].transpose]
        member = Member.where(first_name: row['First Name'], last_name: row['Last Name'], middle_name: row['Middle Name']).first_or_create! do |m|
          m.account_number = row["Account Number"]
          m.sex = row["Sex"].downcase
          m.date_of_birth = Date.parse(row["Date of Birth"].to_s)
          m.civil_status = row["Civil Status"].downcase
          Organizations::OrganizationMember.create(organization_membership: m, organization: Organization.find_by(name: row["Organization"]))
          Contact.create(contactable: m, number: row["Contact Number"])
          Address.create(addressable: m, current: true, municipality: Addresses::Municipality.find_by(name: row["Municipality"]), complete_address: row["Complete Address"])
          Tin.create(tinable: m, number: row["TIN Number"])
          m.office = CoopConfigurationsModule::Offices::MainOffice.find_by(name: row["Office"])
          Membership.create!(account_number: row["Account Number"], cooperator: m, membership_date: Date.parse(row["Membership Date"].to_s), cooperative: Cooperative.find_by(name: row["Cooperative"]))
          m.save        
        end
      end
    end
  end
end
