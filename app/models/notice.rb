class Notice < ApplicationRecord
  belongs_to :notified, polymorphic: true
end
