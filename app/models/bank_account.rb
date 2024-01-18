class BankAccount < ApplicationRecord
  include PgSearch::Model
  pg_search_scope :text_search, against: %i[bank_name bank_address account_number]
  has_one_attached :avatar

  belongs_to :office,                   class_name: 'Cooperatives::Office'
  belongs_to :cash_account,             class_name: 'AccountingModule::Account'
  belongs_to :interest_revenue_account, class_name: 'AccountingModule::Account'
  validates :bank_name, :bank_address, :account_number, presence: true
  before_save :set_default_image

  delegate :entries, to: :cash_account
  delegate :balance, :debits_balance, :credits_balance, to: :cash_account

  def name
    bank_name
  end

  def earned_interests(args = {})
    interest_revenue_account.balance(args)
  end

  private

  def set_default_image
    return if avatar.attachment.present?

    avatar.attach(io: Rails.root.join('app/assets/images/bank.png').open, filename: 'default-image.png', content_type: 'image/png')
  end
end
