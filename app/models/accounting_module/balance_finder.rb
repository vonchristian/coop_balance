module AccountingModule
  module BalanceFinder
    def balance(hash={})
      if hash[:from_date].present? && hash[:to_date].present?
        date_range = DateRange.new(from_date: hash[:from_date], to_date: hash[:to_date])
        joins(:entry, :account).where('entries.entry_date' => (date_range.start_date)..(date_range.end_date)).sum(:amount)
      elsif hash[:commercial_document_id].present?
        where('commercial_document_id' => hash[:commercial_document_id]).sum(:amount)
      elsif hash[:office_id].present?
        joins(:entry, :account).where('entries.office_id' => hash[:office_id]).sum(:amount)
      else
        joins(:entry, :account).sum(:amount)
      end
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
