class Voucher < ApplicationRecord
  belongs_to :voucherable, polymorphic: true
end
