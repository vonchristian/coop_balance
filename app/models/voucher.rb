class Voucher < ApplicationRecord
  belongs_to :voucherable, polymorphic: true
  belongs_to :payee, polymorphic: true
  def for_loan?
    voucherable_type == "LoansModule::Loan"
  end
  def amount 
    voucherable.voucherable_amount
  end
  
  def self.generate_number_for(voucher)
  	if self.last.present?
      voucher.number = "#{self.last.number.succ.rjust(12, '0')}"
    else 
     voucher.number =  "#{1.to_s.rjust(12, '0')}"
    end
  end
end
