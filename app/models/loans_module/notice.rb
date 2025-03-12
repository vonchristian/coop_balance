module LoansModule
  class Notice < ApplicationRecord
    belongs_to :notified, polymorphic: true

    def self.first_notice
      LoansModule::Notices::FirstNotice.new
    end

    def self.for(from_date, to_date)
      return unless from_date && to_date

      where("date" => from_date..to_date)
    end
  end
end
