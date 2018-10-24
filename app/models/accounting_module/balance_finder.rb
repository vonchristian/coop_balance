module AccountingModule
  module BalanceFinder
    def balance(args={})
      from_date = args[:from_date]
      to_date = args[:to_date]
      commercial_document = args[:commercial_document]

      if commercial_document.present? && from_date.present? && to_date.present?
        balance_for(args).
        entered_on(args).
        sum(:amount)

      elsif args[:cooperative_service_id].present? && to_date.present?
        includes(:entry).where('entries.cancelled' => false).where('entries.cooperative_service_id' => args[:cooperative_service_id]).
        entered_on(from_date: Date.today - 999.years, to_date: args[:to_date]).
        sum(:amount)

      elsif commercial_document.blank? && from_date.present? && to_date.present?
        entered_on(args).
        sum(:amount)

      elsif commercial_document.present? && from_date.blank? && to_date.blank?
        balance_for(args).
        sum(:amount)

      elsif commercial_document.blank? && from_date.blank? && to_date.present?
        entered_on(from_date: Date.today - 999.years, to_date: args[:to_date]).
        sum(:amount)

      elsif args[:cooperative_service_id].present? && to_date.present?
        includes(:entry).where('entries.cancelled' => false).where('entries.cooperative_service_id' => args[:cooperative_service_id]).
        entered_on(from_date: Date.today - 999.years, to_date: args[:to_date]).
        sum(:amount)

      elsif args[:cooperative_service_id].present? && to_date.blank?
        includes(:entry).where('entries.cooperative_service_id' => args[:cooperative_service_id]).
        sum(:amount)

      else
        includes(:entry).where('entries.cancelled' => false).sum(:amount)
      end
    end

    def balance_for(args={})
      includes(:entry).where('entries.cancelled' => false).
      where(commercial_document: args[:commercial_document])
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
