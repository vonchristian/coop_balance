class Member < ApplicationRecord
  include Avatarable
  enum sex: [:male, :female, :other]
  has_many :loans, class_name: "LoansDepartment::Loan"
  has_many :addresses, as: :addressable
  has_many :savings
  has_many :share_capitals
  has_many :time_deposits

  has_attached_file :avatar,
  styles: { large: "120x120>",
           medium: "70x70>",
           thumb: "40x40>",
           small: "30x30>",
           x_small: "20x20>"},
  # default_url: ":style/profile_default.jpg",
  :path => ":rails_root/public/system/:attachment/:id/:style/:filename",
  :url => "/system/:attachment/:id/:style/:filename"
  validates_attachment_content_type :avatar, content_type: /\Aimage\/.*\Z/


  def full_name
    "#{last_name}, #{first_name} #{middle_name}."
  end
  def first_and_last_name
    "#{first_name} #{last_name}"
  end
  def current_address
    addresses.order(created_at: :asc).last.try(:details)
  end
  def avatar_text
    first_name.chr
  end
end
