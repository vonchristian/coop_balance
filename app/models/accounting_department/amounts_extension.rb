module AccountingDepartment
  module AmountsExtension
    def balance(hash={})
      if hash[:from_date] && hash[:to_date]
        from_date = hash[:from_date].kind_of?(DateTime) ? hash[:from_date] : DateTime.parse(hash[:from_date].strftime('%Y/%m/%d'))
        to_date = hash[:to_date].kind_of?(DateTime) ? hash[:to_date] : DateTime.parse(hash[:to_date].strftime('%Y/%m/%d'))
        includes([:entry, :account]).where('entries.entry_date' => from_date..to_date).sum(:amount)
      elsif hash[:from_date] && hash[:to_date] && hash[:barangay_id]
          from_date = hash[:from_date].kind_of?(Date) ? hash[:from_date] : DateTime.parse(hash[:from_date].strftime('%Y/%m/%d'))
          to_date = hash[:to_date].kind_of?(Date) ? hash[:to_date] : DateTime.parse(hash[:to_date].strftime('%Y/%m/%d'))
          includes([:entry, :account]).where('entries.entry_date' => from_date..to_date).where('entries.barangay_id' => hash[:barangay_id]).sum(:amount)
        else
        sum(:amount)
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
