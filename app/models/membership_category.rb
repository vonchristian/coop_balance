class MembershipCategory < ApplicationRecord
  belongs_to :cooperative

  validates :title, presence: true, uniqueness: { scope: :cooperative_id }
  def regular_member?
    title == 'Regular Member'
  end 

  def associate_member?
    title == "Associate Member"
  end 
end
