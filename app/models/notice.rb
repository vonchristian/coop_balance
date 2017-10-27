class Notice < ApplicationRecord
  belongs_to :notified, polymorphic: true
  
  def self.for(from_date, to_date)
      if from_date && to_date
       
        where('date' => from_date..to_date)
      end
    end
end
