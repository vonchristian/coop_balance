module TimeDeposits
  class TermExtension
    include ActiveModel::Model
    attr_accessor :or_number, :renewal_date, :member_id, :recorder_id, :term, :time_deposit_id

    def save
      ActiveRecord::Base.transaction do
        create_term
      end
    end

    def create_term
      Term.create!(
      termable: find_time_deposit,
      term: term,
      effectivity_date: renewal_date,
      maturity_date: (renewal_date.to_date + (term.to_i.months)))
    end
    def find_time_deposit
      DepositsModule::TimeDeposit.find_by(id: time_deposit_id)
    end
  end
end
