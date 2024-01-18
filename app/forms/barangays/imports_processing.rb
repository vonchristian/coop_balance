module Barangays
  class ImportsProcessing
    require 'roo'
    include ActiveModel::Model

    attr_accessor :file, :cooperative_id

    def parse_records!
      barangays_spreadsheet = Roo::Spreadsheet.open(file.path)
      header = barangays_spreadsheet.row(1)
      (2..barangays_spreadsheet.last_row).each do |i|
        row = [header, barangays_spreadsheet.row(i)].transpose.to_h
        ActiveRecord::Base.transaction do
          Addresses::Barangay.where(name: row['BARANGAY']).where(municipality: find_municipality(row)).first_or_create! do |s|
            s.cooperative_id = cooperative_id
          end
        end
      end
    end

    def find_municipality(row)
      Addresses::Municipality.where(name: row['MUNICIPALITY']).where(province: find_province(row)).first_or_create do |m|
        m.cooperative_id = cooperative_id
      end
    end

    def find_province(row)
      Addresses::Province.find_or_create_by(name: row['PROVINCE'])
    end
  end
end