module AccountingModule
  module BalanceFinder
    def balance(options={})
      from_date = options[:from_date]
      to_date = options[:to_date]
      commercial_document = options[:commercial_document]
      if commercial_document.present? && from_date.present? && to_date.present?
        balance_for(options).
        entered_on(options).
        sum(:amount)
      elsif commercial_document.blank? && from_date.present? && to_date.present?
        entered_on(options).
        sum(:amount)
      elsif commercial_document.present? && from_date.blank? && to_date.blank?
        balance_for(options).
        sum(:amount)
      elsif commercial_document.blank? && from_date.blank? && to_date.present?
        entered_on(from_date: AccountingModule::Entry.order(entry_date: :asc).first.try(:entry_date) || Date.today, to_date: options[:to_date]).
        sum(:amount)
      else
        sum(:amount)
      end
    end

    def balance_for(options={})
      includes(:entry).
      where(commercial_document: options[:commercial_document])
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
