class Contact < ApplicationRecord
  belongs_to :contactable, polymorphic: true
  def self.current
    order(created_at: :desc).first || NullContact.new
  end
end
