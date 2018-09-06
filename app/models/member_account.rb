class MemberAccount < ApplicationRecord
    belongs_to :member
    devise :database_authenticatable, :registerable,
           :recoverable, :rememberable, :validatable, :lockable,  :timeoutable
  end
