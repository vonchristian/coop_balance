require 'csv'
class Member < ApplicationRecord
  include Avatarable
  include PgSearch 
  pg_search_scope :text_search, :against => [:passbook_number, :first_name, :middle_name, :last_name]
  multisearchable against: [:passbook_number, :first_name, :last_name, :middle_name]
  enum sex: [:male, :female, :other]
  
  has_one :tin, as: :tinable
  has_one :membership, as: :memberable
  has_many :member_occupations
  has_many :occupations, through: :member_occupations
  has_many :loans, class_name: "LoansModule::Loan"
  has_many :addresses, as: :addressable
  has_many :savings, class_name: "MembershipsModule::Saving"
  has_many :share_capitals, class_name: "MembershipsModule::ShareCapital"
  has_many :time_deposits, class_name: "MembershipsModule::TimeDeposit"
  has_many :program_subscriptions, class_name: "MembershipsModule::ProgramSubscription"
  has_many :programs, through: :program_subscriptions
  has_many :orders, class_name: "StoreModule::Order"
  has_many :real_properties

  has_attached_file :avatar,
  styles: { large: "120x120>",
           medium: "70x70>",
           thumb: "40x40>",
           small: "30x30>",
           x_small: "20x20>"},
  default_url: ":style/profile_default.jpg",
  :path => ":rails_root/public/system/:attachment/:id/:style/:filename",
  :url => "/system/:attachment/:id/:style/:filename"
  validates_attachment_content_type :avatar, content_type: /\Aimage\/.*\Z/
  def self.import(file)
    CSV.foreach(file.path, headers: true) do |row|
      Member.create!(row.to_hash)
    end 
  end
  def name #for search results
    full_name
  end
  def full_name
    "#{last_name}, #{first_name} #{middle_name}"
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
