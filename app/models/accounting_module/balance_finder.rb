module AccountingModule
  module BalanceFinder
    def balance(hash={})
      first_entry = AccountingModule::Entry.order(entry_date: :asc).first
      if hash[:from_date].present? && hash[:to_date].present? && hash[:recorder_id].present?
        balance_for_recorder(hash[:recorder_id]) + balance_for_date_range(hash[:from_date], hash[:to_date])
      elsif hash[:from_date].present? && hash[:to_date].present? && hash[:recorder_id].nil?
        balance_for_date_range(hash[:from_date], hash[:to_date])
      elsif hash[:to_date].present? && hash[:from_date].nil? && hash[:recorder_id].present?
        from_date = first_entry ? Chronic.parse(first_entry.entry_date.strftime('%Y-%m-%d 12:59:59')) : Time.zone.now.beginning_of_day
        balance_for_recorder(hash[:recorder_id]) + balance_for_date_range(from_date, hash[:to_date])
      elsif hash[:to_date].present? && hash[:from_date].nil? && hash[:recorder_id].nil?
        from_date = first_entry ? Chronic.parse(first_entry.entry_date.strftime('%Y-%m-%d 12:59:59')) : Time.zone.now.beginning_of_day
        balance_for_date_range(from_date, hash[:to_date])
      elsif hash[:recorder_id].present? && hash[:from_date].nil? && hash[:to_date].nil?
        balance_for_recorder(hash[:recorder_id])
      elsif hash[:commercial_document_id].present?
        balance_for_commercial_document(hash[:commercial_document_id])
      elsif hash[:office_id].present?
        joins(:entry, :account).where('entries.office_id' => hash[:office_id]).total
      else
        joins(:entry, :account).total
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
    private
    def balance_for_recorder(recorder)
      joins(:entry, :account).where('recorder_id' => recorder).total
    end
    def balance_for_date_range(from_date, to_date)
      date_range = DateRange.new(from_date: from_date, to_date: to_date)
      joins(:entry, :account).where('entries.entry_date' => (date_range.start_date)..(date_range.end_date)).total
    end
    def balance_for_commercial_document(commercial_document)
      where('commercial_document_id' => commercial_document).total
    end
  end
end
