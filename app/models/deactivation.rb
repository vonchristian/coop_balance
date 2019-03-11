class Deactivation < ApplicationRecord
  belongs_to :deactivatable, polymorphic: true
  def self.recent
    order(deactivated_at: :desc).first
  end 
end
