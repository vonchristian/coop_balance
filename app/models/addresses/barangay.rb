module Addresses
  class Barangay < ApplicationRecord
    include PgSearch::Model

    pg_search_scope( :search, :against => [:name], :associated_against => { :municipality => [:name] },
                    using: { tsearch: { prefix: true } } )

    has_one_attached :avatar
    belongs_to :municipality
    has_many :streets
    has_many :loans, class_name: "LoansModule::Loan"
    has_many :savings, class_name: "MembershipsModule::Saving"
    has_many :share_capitals, class_name: "MembershipsModule::ShareCapital"
    has_many :time_deposits, class_name: "MembershipsModule::TimeDeposit"

    has_many :addresses
    has_many :members, through: :addresses, source: :addressable, source_type: "Member"
    has_many :organizations, through: :addresses, source: :addressable, source_type: "Organization"

    validates :name, presence: true

    before_save :set_default_avatar

    delegate :name, to: :municipality, prefix: true
    def name_and_municipality
      "#{name}, #{municipality_name}"
    end 
    private
    def set_default_avatar
      if avatar.attachment.blank?
        self.avatar.attach(io: File.open(Rails.root.join('app', 'assets', 'images', 'default_business_logo.jpg')), filename: 'default-image.jpg', content_type: 'image/jpg')
      end
    end
  end
end
