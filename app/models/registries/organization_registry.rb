require "roo"
module Registries
  class OrganizationRegistry < Registry
    def parse_for_records
      organization_spreadsheet = Roo::Spreadsheet.open(spreadsheet.path)
      header = organization_spreadsheet.row(1)
      (2..organization_spreadsheet.last_row).each do |i|
        row = [ header, organization_spreadsheet.row(i) ].transpose.to_h
        ActiveRecord::Base.transaction do
          Organization.where(name: row["Name"], abbreviated_name: row["Abbreviation"]).first_or_create! do |m|
            m.abbreviated_name = row["Abbreviation"].upcase
          end
        end
      end
    end
  end
end
