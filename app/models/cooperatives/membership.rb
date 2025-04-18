module Cooperatives
  class Membership < ApplicationRecord
    include PgSearch::Model
    pg_search_scope :text_search, against: [ :search_term ]

    BLACKLISTED_MEMBERSHIP_TYPE = %w[organization special_depositor].freeze

    belongs_to :cooperator, polymorphic: true
    belongs_to :membership_category
    belongs_to :cooperative
    belongs_to :office,                 class_name: "Cooperatives::Office"
    has_many :membership_beneficiaries, class_name: "MembershipsModule::MembershipBeneficiary"
    has_many :beneficiaries,            through: :membership_beneficiaries

    validates :cooperator_type, presence: true
    validates :cooperator_id,  uniqueness: { scope: :cooperative_id }
    validates :account_number, presence: true, uniqueness: true
    delegate :name, to: :cooperative, prefix: true
    delegate :title, to: :membership_category, prefix: true
    delegate :regular_member?, :associate_member?, to: :membership_category

    def self.for_cooperative(cooperative)
      where(cooperative: cooperative)
    end

    def self.whitelisted_membership_types
      membership_types.keys - BLACKLISTED_MEMBERSHIP_TYPE
    end

    def self.approved_at(args = {})
      from_date   = args[:from_date]
      to_date     = args[:to_date]
      date_range  = DateRange.new(from_date: from_date, to_date: to_date)
      approved.where("approval_date" => date_range.range)
    end

    def self.for_cooperative(args = {})
      where(cooperative: args[:cooperative])
    end

    def self.approved_memberships(args = {}); end

    def self.current
      order(created_at: :desc).first || "None"
    end
  end
end
