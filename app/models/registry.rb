require 'roo'
class Registry < ApplicationRecord
  has_one :voucher, as: :commercial_document
  belongs_to :cooperative
  belongs_to :office,      class_name: "Cooperatives::Office"
  belongs_to :store_front, optional: true
  belongs_to :employee,    class_name: "User", foreign_key: 'employee_id'
  has_one_attached :spreadsheet
end

