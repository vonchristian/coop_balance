module Members
  class LoansLedgerPdf < Prawn::Document
    TABLE_WIDTH = [40, 50, 50, 50, 50, 50, 50].freeze
    attr_reader :member, :view_context, :cooperative, :title, :entries, :loan_product, :forwarded_loans, :forwarded_loan

    def initialize(args = {})
      super(margin: 10, page_size: [360, 468], page_layout: :portrait) # [340, 448]
      @member = args[:member]
      @title = args[:title]
      @entries = args[:entries]
      @loan_product = args[:loan_product]
      @forwarded_loans = args[:forwarded_loans]
      @forwarded_loan = @forwarded_loans.last
      @cooperative = args[:cooperative]
      @view_context = args[:view_context]
      heading
      transactions
    end

    private

    def price(number)
      view_context.number_to_currency(number, unit: '')
    end

    def heading
      bounding_box [0, 448], width: 175 do
        # stroke_bounds
        text title, style: :bold, size: 8
        move_down 3
        text member.name.to_s, size: 8
      end
      bounding_box [175, 448], width: 40 do
        # stroke_bounds
        image Rails.root.join("app/assets/images/#{cooperative.abbreviated_name.downcase}_logo.jpg").to_s, width: 30, height: 30
      end
      bounding_box [215, 448], width: 125 do
        # stroke_bounds
        text cooperative.name.try(:upcase).to_s, style: :bold, size: 8
        text cooperative.address.to_s, size: 8
      end
      move_down 10
      stroke do
        stroke_color '000000'
        line_width 0.2
        stroke_horizontal_rule
        move_down 2
      end
    end

    def transactions
      table_header
      table(transactions_data, cell_style: { padding: [1, 1, 2, 1], size: 7 },
                               column_widths: TABLE_WIDTH) do
        cells.borders = []
        column(2).align = :right
        column(3).align = :right
        column(4).align = :right
        column(5).align = :right
        column(6).align = :right
      end
    end

    def transactions_data
      @transactions_data ||= @entries.order(:entry_date).map do |entry|
        [entry.entry_date.strftime('%D'),
         entry.reference_number.presence || 'FWD',
         price(entry.debit_amounts.for_account(account_id: loan_product.current_account_id).total),
         price(total_payment(entry)),
         price(member.loans_for(loan_product: loan_product).sum { |l| l.principal_balance(to_date: EntryDateTime.new(entry: entry).set) }),
         price(entry.credit_amounts.for_account(account_id: loan_product.interest_revenue_account.id).total),
         price(entry.credit_amounts.for_account(account_id: loan_product.penalty_revenue_account.id).total)]
      end
    end

    def table_header
      table([['DATE', 'OR/CDV #', 'LOAN', 'PAYMENT', 'BALANCE', 'INTEREST', 'FINES']],
            header: true, cell_style: { padding: [1, 1, 2, 1], size: 7 },
            column_widths: TABLE_WIDTH) do
        cells.borders = %i[top bottom]
        row(0).font_style = :bold
        column(2).align = :right
        column(3).align = :right
        column(4).align = :right
        column(5).align = :right
        column(6).align = :right
      end
    end

    def total_payment(entry)
      credit_amounts_for_current_account = entry.credit_amounts.for_account(account_id: loan_product.current_account_id)
      debit_amounts_for_current_account = entry.debit_amounts.for_account(account_id: loan_product.current_account_id)
      if credit_amounts_for_current_account.present? && debit_amounts_for_current_account.present?
        credit_amounts_for_current_account.total
      else
        credit_amounts_for_current_account.total +
          entry.credit_amounts.for_account(account_id: loan_product.interest_revenue_account.id).total
      end
    end
  end
end