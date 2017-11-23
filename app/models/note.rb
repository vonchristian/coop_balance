class Note < ApplicationRecord
  belongs_to :noteable, polymorphic: true
  belongs_to :noter, class_name: "User", foreign_key: 'noter_id'
end
