class Note < ApplicationRecord
  belongs_to :noteable, polymorphic: true
  belongs_to :noter,    class_name: 'User'
  delegate :name, to: :noter, prefix: true

  validates :title, :content, presence: true

  before_save :set_default_date

  private

  def set_default_date
    self.date ||= Time.zone.now
  end
end
