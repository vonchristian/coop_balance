class Note < ApplicationRecord
  belongs_to :noteable, polymorphic: true
  belongs_to :noter, class_name: "User", foreign_key: 'noter_id'
  delegate :name, to: :noter, prefix: true

  validates :date, :title, :content, :noter_id, presence: true
end
