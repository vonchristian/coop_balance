module TimeDeposits
  class TermExtension
    include ActiveModel::Model
    attr_accessor :or_number, :date_deposited, :amount,:member_id, :recorder_id, :number_of_days, :time_deposit_id

    def save
      ActiveRecord::Base.transaction do
        create_term
      end
    end

    def create_term
      Term.create!(
      termable: find_time_deposit,
      term: number_of_days,
      effectivity_date: date_deposited,
      maturity_date: (date_deposited.to_date + (number_of_days.to_i.days)))
    end
    def find_time_deposit
      MembershipsModule::TimeDeposit.find_by(id: time_deposit_id)
    end
  end
end
