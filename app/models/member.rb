class Member < ApplicationRecord
  enum sex: [:male, :female, :other]
end
