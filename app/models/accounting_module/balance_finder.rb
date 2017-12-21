module AccountingModule
  module BalanceFinder
    def balance(hash={})
      if hash[:from_date].present? && hash[:to_date].present? && hash[:recorder_id].present?
        from_date = Chronic.parse(hash[:from_date].to_date)
        to_date = Chronic.parse(hash[:to_date].to_date)
        joins(:entry, :account).where('entries.recorder_id' => hash[:recorder_id]).where('entries.entry_date' => (from_date.beginning_of_day)..(to_date.end_of_day)).sum(:amount)
      elsif hash[:from_date].present? && hash[:to_date].present? && hash[:recorder_id].nil?
        from_date = Chronic.parse(hash[:from_date].strftime('%Y-%m-%d 12:00:00'))
        to_date = Chronic.parse(hash[:to_date].strftime('%Y-%m-%d 12:59:59'))
        joins(:entry, :account).where('entries.entry_date' =>  (from_date.beginning_of_day)..(to_date.end_of_day)).sum(:amount)

      elsif hash[:to_date].present? && hash[:from_date].nil? && hash[:recorder_id].present?
        first_entry = AccountingModule::Entry.order(entry_date: :asc).first
        from_date = first_entry ? Chronic.parse(first_entry.entry_date.strftime('%Y-%m-%d 12:59:59')) : Time.zone.now
        to_date = Chronic.parse(hash[:to_date].strftime('%Y-%m-%d 12:59:59'))
        joins(:entry, :account).where('entries.recorder_id' => hash[:recorder_id]).where('entries.entry_date' => (from_date.beginning_of_day)..(to_date.end_of_day)).sum(:amount)
      elsif hash[:to_date].present? && hash[:from_date].nil? && hash[:recorder_id].nil?
        first_entry = AccountingModule::Entry.order(entry_date: :asc).first
        from_date = first_entry ? Chronic.parse(first_entry.entry_date.strftime('%Y-%m-%d 12:59:59')) : Time.zone.now.beginning_of_day
        to_date = Chronic.parse(hash[:to_date].to_date)
        joins(:entry, :account).where('entries.entry_date' => (from_date.beginning_of_day)..(to_date.end_of_day)).sum(:amount)
      elsif hash[:recorder_id].present?
        joins(:entry, :account).where('entries.recorder_id' => hash[:recorder_id]).sum(:amount)
       elsif hash[:commercial_document_id].present?
        where('commercial_document_id' => hash[:commercial_document_id]).sum(:amount)
      elsif hash[:office_id].present?
        joins(:entry, :account).where('entries.branch_office_id' => hash[:branch_office_id]).sum(:amount)
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
