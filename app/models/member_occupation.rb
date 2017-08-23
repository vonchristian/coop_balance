class MemberOccupation < ApplicationRecord
  belongs_to :member
  belongs_to :occupation
end
