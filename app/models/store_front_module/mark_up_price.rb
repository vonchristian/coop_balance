module StoreFrontModule
  class MarkUpPrice < ApplicationRecord
    belongs_to :unit_of_measurement
    before_save :set_default_date
    validates :price, presence: true, numericality: true
    def self.current
      order(date: :desc).first
    end

    private

    def set_default_date
      todays_date = ActiveRecord::Base.default_timezone == :utc ? Time.now.utc : Time.now
      self.date ||= todays_date
    end
  end
end
