require 'prawn/icon'
module StatementOfAccounts
  class ShareCapitalPdf < Prawn::Document
    attr_reader :share_capital, :cooperative, :view_context

    def initialize(args)
      super(margin: 40, page_size: 'A4', page_layout: :portrait)
      @share_capital = args[:share_capital]
      @cooperative     = @share_capital.cooperative
      @view_context    = args[:view_context]
      heading
      share_capital_details
      transaction_details
    end

    private

    def price(number)
      view_context.number_to_currency(number, unit: 'P ')
    end

    def debit_cash_amount(entry)
      amount = entry.debit_amounts.for_account(account_id: share_capital.share_capital_equity_account.id).sum(&:amount)
      if amount.zero?
        ''
      else
        price(amount)
      end
    end

    def credit_cash_amount(entry)
      amount = entry.credit_amounts.for_account(account_id: share_capital.share_capital_equity_account.id).sum(&:amount)
      if amount.zero?
        ''
      else
        price(amount)
      end
    end

    def heading
      bounding_box [280, 770], width: 50 do
        image Rails.root.join("app/assets/images/#{cooperative.abbreviated_name.downcase}_logo.jpg").to_s, width: 55, height: 55
      end
      bounding_box [340, 770], width: 200 do
        text cooperative.abbreviated_name.to_s, style: :bold, size: 20
        text cooperative.name.try(:upcase).to_s, size: 8
        text cooperative.address.to_s, size: 8
      end
      bounding_box [0, 770], width: 400 do
        text 'STATEMENT OF ACCOUNT', style: :bold, size: 12
        text share_capital.subscriber_name.upcase.to_s, size: 10
        icon "<icon size='10'>fa-map-marker</icon>  #{share_capital.subscriber_current_address_complete_address}", inline_format: true, size: 10
        move_down 2
        icon "<icon size='10'>fa-mobile</icon>  #{share_capital.subscriber_current_contact_number}", inline_format: true, size: 10
      end
      move_down 20
      stroke do
        stroke_color 'CCCCCC'
        line_width 0.5
        stroke_horizontal_rule
        move_down 10
      end
    end

    def share_capital_details
      text 'PAID UP BALANCE', size: 8
      move_down 5
      text price(share_capital.balance).to_s, size: 18
    end

    def transaction_details
      move_down 10
      text 'TRANSACTIONS HISTORY', size: 10, style: :bold
      move_down 2
      table(transactions_data, cell_style: { inline_format: true, size: 10, padding: [5, 5, 5, 5] }, column_widths: [70, 150, 60, 70, 70, 90]) do
        column(2).align = :right
        column(3).align = :right
        column(4).align = :right
        column(5).align = :right
      end
    end

    def transactions_data
      [['Date', 'Description', 'Ref #', 'Debits', 'Credits', 'Balance']] +
        @transactions_data ||= share_capital.entries.sort_by(&:entry_date).map { |a|
          [a.entry_date.strftime('%b %e, %Y'),
           a.description,
           a.reference_number,
           debit_cash_amount(a),
           credit_cash_amount(a),
           price(share_capital.balance(to_date: a.entry_date, to_time: a.created_at))]
        }
    end
  end
end
