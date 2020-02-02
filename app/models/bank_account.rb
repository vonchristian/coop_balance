class BankAccount < ApplicationRecord
  include PgSearch::Model
  pg_search_scope :text_search, against: [:bank_name, :bank_address, :account_number]
  has_one_attached :avatar
  belongs_to :cooperative
  belongs_to :office,                   class_name: "Cooperatives::Office"
  belongs_to :cash_account,             class_name: "AccountingModule::Account"
  belongs_to :interest_revenue_account, class_name: "AccountingModule::Account"
  validates :bank_name, :bank_address, :account_number, presence: true
  before_save :set_default_image

  delegate :entries, to: :cash_account

  def name
    bank_name
  end

  def balance(args = {})
    cash_account.balance(args)
  end

  def debits_balance(args = {})
   cash_account.debits_balance(args)
  end

  def credits_balance(args = {})
    cash_account.credits_balance(args)
  end

  def earned_interests(args={})
    interest_revenue_account.balance(args)
  end

  private
  def set_default_image
    if avatar.attachment.blank?
      self.avatar.attach(io: File.open(Rails.root.join('app', 'assets', 'images', 'bank.png')), filename: 'default-image.png', content_type: 'image/png')
    end
  end
end
