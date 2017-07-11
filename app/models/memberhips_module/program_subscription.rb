class ProgramSubscription < ApplicationRecord
  belongs_to :program
  belongs_to :member
  has_many :entries, class_name: "AccountingDepartment::Entry", as: :commercial_document
  delegate :name, :contribution, to: :program
  def paid?
  	entries.last.present? && entries.last.entry_date.between?(Time.zone.now.beginning_of_year, Time.zone.now.end_of_year)
  end
end
