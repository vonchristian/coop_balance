module AccountingModule
  module AmountsExtension
    def balance(hash={})
      if hash[:from_date] && hash[:to_date] && hash[:recorder_id].nil?
        from_date = hash[:from_date].kind_of?(DateTime) ? hash[:from_date] : DateTime.parse(hash[:from_date].strftime('%Y-%m-%d 12:00:00'))
        to_date = hash[:to_date].kind_of?(DateTime) ? hash[:to_date] : DateTime.parse(hash[:to_date].strftime('%Y-%m-%d 12:59:59'))
        joins(:entry, :account).where('entries.entry_date' => from_date..to_date).sum(:amount)
      elsif hash[:from_date] && hash[:to_date] && hash[:recorder_id]
        from_date = hash[:from_date].kind_of?(DateTime) ? hash[:from_date] : DateTime.parse(hash[:from_date].strftime('%Y-%m-%d 12:00:00'))
        to_date = hash[:to_date].kind_of?(DateTime) ? hash[:to_date] : DateTime.parse(hash[:to_date].strftime('%Y-%m-%d 12:59:59'))
        employee = User.find(hash[:recorder_id])
        joins(:entry, :account).where('entries.recorder_id' => employee.id).where('entries.entry_date' => (from_date.beginning_of_day)..(to_date.end_of_day)).sum(:amount)
      elsif hash[:recorder_id]
        employee = User.find(hash[:recorder_id])
        joins(:entry, :account).where('entries.recorder_id' => employee.id).sum(:amount) 
       elsif hash[:commercial_document_id]
        joins(:entry, :account).where('entries.commercial_document_id' => hash[:commercial_document_id]).sum(:amount) 
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
