class Registry < ApplicationRecord
  belongs_to :employee, class_name: "User", foreign_key: 'employee_id'
  has_attached_file :spreadsheet, :path => ":rails_root/public/system/:attachment/:id/:filename"
  do_not_validate_attachment_file_type :spreadsheet
end
