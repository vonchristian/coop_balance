class ShareCapitalProductShare < ApplicationRecord
  belongs_to :share_capital
  def self.total_shares
    sum(&:share_count)
  end
end
