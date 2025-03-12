module Members
  class ShareCapitalLedgerPdf < Prawn::Document
    TABLE_WIDTH = [ 50, 50, 80, 80, 80 ].freeze
    attr_reader :member, :view_context, :cooperative, :entries, :share_capital, :equity_account

    def initialize(args = {})
      super(margin: 10, page_size: [ 360, 468 ], page_layout: :portrait) # [340, 448]
      @share_capital = args[:share_capital]
      @equity_account = @share_capital.share_capital_equity_account
      @entries = args[:entries]
      @member = @share_capital.subscriber
      @cooperative = @share_capital.cooperative
      @view_context = args[:view_context]
      heading
      transactions
    end

    private

    def price(number)
      view_context.number_to_currency(number, unit: "")
    end

    def heading
      bounding_box [ 0, 448 ], width: 175 do
        # stroke_bounds
        text "Share Capital", style: :bold, size: 8
        move_down 3
        text member.name.to_s, size: 8
      end
      bounding_box [ 175, 448 ], width: 40 do
        # stroke_bounds
        image Rails.root.join("app/assets/images/#{cooperative.abbreviated_name.downcase}_logo.jpg").to_s, width: 30, height: 30
      end
      bounding_box [ 215, 448 ], width: 125 do
        # stroke_bounds
        text cooperative.name.try(:upcase).to_s, style: :bold, size: 8
        text cooperative.address.to_s, size: 8
      end
      move_down 10
      stroke do
        stroke_color "000000"
        line_width 0.2
        stroke_horizontal_rule
        move_down 2
      end
    end

    def transactions
      table_header
      table(transactions_data, cell_style: { padding: [ 1, 1, 2, 1 ], size: 7 },
                               column_widths: TABLE_WIDTH) do
        cells.borders = []
        column(2).align = :right
        column(3).align = :right
        column(4).align = :right
      end
    end

    def transactions_data
      @transactions_data ||= @entries.order(:entry_date).map do |entry|
        [ entry.entry_date.strftime("%D"),
         entry.reference_number.presence || "FWD",
         price(deposit_amount(entry)),
         price(widthrawal_amount(entry)),
         price(share_capital.balance(to_date: EntryDateTime.new(entry: entry).set)) ]
      end
    end

    def table_header
      table([ [ "DATE", "OR/CDV #", "DEPOSIT", "WIDTHRAWAL", "BALANCE" ] ],
            header: true, cell_style: { padding: [ 1, 1, 2, 1 ], size: 7 },
            column_widths: TABLE_WIDTH) do
        cells.borders = %i[top bottom]
        row(0).font_style = :bold
        column(2).align = :right
        column(3).align = :right
        column(4).align = :right
      end
    end

    def deposit_amount(entry)
      if credit_amounts_for_equity_account(entry).present? # && credit_amounts_for_equity_account(entry).pluck(:commercial_document).include?(share_capital)
        credit_amounts_for_equity_account(entry).total
      else
        0
      end
    end

    def widthrawal_amount(entry)
      if debit_amounts_for_equity_account(entry).present? # && debit_amounts_for_equity_account(entry).pluck(:commercial_document).include?(share_capital)
        debit_amounts_for_equity_account(entry).total
      else
        0
      end
    end

    def credit_amounts_for_equity_account(entry)
      entry.credit_amounts.for_account(account_id: equity_account.id)
    end

    def debit_amounts_for_equity_account(entry)
      entry.debit_amounts.for_account(account_id: equity_account.id)
    end
  end
end
