require 'prawn/icon'
module SavingsAccounts
  class StatementOfAccountPdf < Prawn::Document
    attr_reader :savings_account, :cooperative, :view_context

    def initialize(args)
      super(margin: 40, page_size: "A4", page_layout: :portrait)
      @savings_account = args[:savings_account]
      @cooperative     = @savings_account.cooperative
      @view_context    = args[:view_context]
      heading
      savings_account_details
      transaction_details
    end
    private
    def price(number)
      view_context.number_to_currency(number, :unit => "P ")
    end
    def debit_cash_amount(entry)
      amount = entry.debit_amounts.total_cash_amount
      if amount.zero?
        ""
      else
        price(amount)
      end
    end
    def credit_cash_amount(entry)
      amount = entry.credit_amounts.total_cash_amount
      if amount.zero?
        ""
      else
        price(amount)
      end
    end
    def heading
      bounding_box [0, 770], width: 50 do
        image "#{Rails.root}/app/assets/images/#{cooperative.abbreviated_name.downcase}_logo.jpg", width: 55, height: 55
      end
      bounding_box [70, 770], width: 200 do
          text "#{cooperative.abbreviated_name }", style: :bold, size: 20
          text "#{cooperative.name.try(:upcase)}", size: 8
          text "#{cooperative.address}", size: 8
      end
      bounding_box [320, 770], width: 400 do
        text "STATEMENT OF ACCOUNT", style: :bold, size: 12
        text "#{savings_account.depositor_name.upcase}", size: 10
        icon "<icon size='10'>fa-map-marker</icon>  #{savings_account.depositor_current_address_complete_address}", inline_format: true, size: 10
        move_down 2
        icon "<icon size='10'>fa-mobile</icon>  #{savings_account.depositor_current_contact_number}", inline_format: true, size: 10

      end
      move_down 15
      stroke do
        stroke_color 'CCCCCC'
        line_width 0.5
        stroke_horizontal_rule
        move_down 10
      end
    end
    def savings_account_details
      text "#{price savings_account.balance}", size: 16
      text "BALANCE", size: 10
    end
    def transaction_details
      move_down 10
      text "TRANSACTIONS HISTORY", size: 10, style: :bold
      move_down 2
      table(transactions_data, cell_style: { inline_format: true, size: 10, :padding => [2,5,2,5]}, column_widths: [70, 150, 60, 70, 70, 90]) do
        column(2).align = :right
        column(3).align = :right
        column(4).align = :right
        column(5).align = :right



      end
    end
    def transactions_data
      [["Date", "Description", "Ref #", "Debit Amount", "Credit Amount", "Balance"]] +
      @transactions_data ||= savings_account.entries.sort_by(&:entry_date).reverse.map{ |a|
       [ a.entry_date.strftime("%b %e, %Y"),
         a.description,
         a.reference_number,
         debit_cash_amount(a),
         credit_cash_amount(a),
         price(savings_account.balance(to_date: a.entry_date))] }
    end
  end
end
