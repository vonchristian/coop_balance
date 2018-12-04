module AccountingModule
  module BalanceFinder
    def balance(args={})
      from_date = args[:from_date]
      to_date = args[:to_date]
      commercial_document = args[:commercial_document]

      if commercial_document.present? && from_date.present? && to_date.present?
        balance_for_commercial_document(args).
        entered_on(args).total_amount

      elsif args[:cooperative_service_id].present? && to_date.present?
        balance_for_cooperative_service(args).
        entered_on(from_date: Date.today - 999.years, to_date: args[:to_date]).
        total_amount

      elsif commercial_document.blank? && from_date.present? && to_date.present?
        entered_on(args).
        total_amount

      elsif commercial_document.present? && from_date.blank? && to_date.blank?
        balance_for_commercial_document(args).
        total_amount

      elsif commercial_document.blank? && from_date.blank? && to_date.present?
        entered_on(from_date: Date.today - 999.years, to_date: args[:to_date]).
        total_amount

      elsif args[:cooperative_service_id].present? && to_date.blank?
        balance_for_cooperative_service(args).
        total_amount
      else
        includes(:entry).where('entries.cancelled' => false).
        total_amount
      end
    end

    def total_amount
      map{ |a| a.amount.amount }.sum
    end

    def balance_for_commercial_document(args={})
      includes(:entry).where('entries.cancelled' => false).
      where(commercial_document: args[:commercial_document])
    end

    def balance_for_cooperative_service(args={})
      includes(:entry).where('entries.cancelled' => false).where('entries.cooperative_service_id' => args[:cooperative_service_id])
    end


    def balance_for_new_record
      balance = BigDecimal.new('0')
      each do |amount_record|
        if amount_record.amount && !amount_record.marked_for_destruction?
          balance += amount_record.amount # unless amount_record.marked_for_destruction?
        end
      end
      return balance
    end
  end
end
