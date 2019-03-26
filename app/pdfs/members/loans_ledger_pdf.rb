module Members
  class LoansLedgerPdf < Prawn::Document

    attr_reader :member, :view_context, :cooperative, :title, :entries, :loan_product, :forwarded_loans, :forwarded_loan

    def initialize(args={})
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
      view_context.number_to_currency(number, :unit => "P ")
    end

    def heading
      bounding_box [0, 448], width: 175 do
        # stroke_bounds
        text title, style: :bold, size: 8
        move_down 3
        text "Borrower: #{member.name}", size: 8
      end
      bounding_box [175, 448], width: 40 do
        # stroke_bounds
        image "#{Rails.root}/app/assets/images/#{cooperative.abbreviated_name.downcase}_logo.jpg", width: 30, height: 30
      end
      bounding_box [215, 448], width: 125 do
        # stroke_bounds
        text "#{cooperative.name.try(:upcase)}", style: :bold, size: 8
        text "#{cooperative.address}", size: 8
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
      table(transactions_data, cell_style: {padding: [1,3,2,3], size: 8 }, 
        column_widths: [50, 50, 80, 80, 80]) do
        cells.borders = [:top]
        column(2).align = :right
        column(3).align = :right
        column(4).align = :right
      end
    end

    def transactions_data
      @table_data ||= @entries.order(:entry_date).map{|e|
        [ e.entry_date.strftime("%D"),
          e.try(:reference_number),
          price(e.debit_amounts.for_account(account_id: loan_product.current_account_id).total),
          price(e.credit_amounts.for_account(account_id: loan_product.current_account_id).total),
          price(member.loans_for(loan_product: loan_product).sum{|l| l.principal_balance(to_date: EntryDateTime.new(entry: e).set)})
        ]
      }
    end

    def table_header
      table([["DATE", "OR/CDV #", "DEBIT", "CREDIT", "BALANCE"]], 
        header: true, cell_style: {padding: [1,3,2,3], size: 8 }, 
        column_widths: [50, 50, 80, 80, 80]) do
        cells.borders = [:bottom]
        row(0).font_style = :bold
        column(2).align = :right
        column(3).align = :right
        column(4).align = :right
      end
      move_down 2
      if forwarded_loans.present?
        table([[forwarded_loan.application_date.strftime("%D"), "FWD",
          price(forwarded_loan.principal_balance(to_date: forwarded_loan.application_date)), "",
          forwarded_loans.sum{|l| l.principal_balance(to_date: forwarded_loan.application_date)}]], 
          cell_style: {padding: [1,3,2,3], size: 8 }, 
          column_widths: [50, 50, 80, 80, 80]) do
          cells.borders = [:top]
          column(2).align = :right
          column(3).align = :right
          column(4).align = :right
        end
      end
    end
  end
end