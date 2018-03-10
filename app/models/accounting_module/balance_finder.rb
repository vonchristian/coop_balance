module AccountingModule
  module BalanceFinder
    def balance(hash={})
      from_date = hash[:from_date]
      to_date = hash[:to_date]
      commercial_document = hash[:commercial_document_id]
      if commercial_document.present? && from_date.present? && to_date.present?
        date_range = DateRange.new(from_date: from_date, to_date: to_date)
        joins(:entry, :account).where('entries.entry_date' => (date_range.start_date)..(date_range.end_date)).
        where(commercial_document_id: commercial_document).
        sum(:amount)
      elsif commercial_document.blank? && from_date.present? && to_date.present?
        date_range = DateRange.new(from_date: from_date, to_date: to_date)
        joins(:entry, :account).where('entries.entry_date' => (date_range.start_date)..(date_range.end_date)).sum(:amount)
      elsif commercial_document.present? && from_date.blank? && to_date.blank?
        where('commercial_document_id' => commercial_document).sum(:amount)
      elsif commercial_document.present? && from_date.present? && to_date.present?
        joins(:entry, :account).where('entries.entry_date' => (date_range.start_date)..(date_range.end_date)).
        where('commercial_document_id' => commercial_document).
        sum(:amount)
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
