require 'prawn/icon'
module StatementOfAccounts
  class LoanPdf < Prawn::Document
    attr_reader :loan, :cooperative, :view_context

    def initialize(args)
      super(margin: 40, page_size: 'A4', page_layout: :portrait)
      @loan = args[:loan]
      @cooperative     = @loan.cooperative
      @view_context    = args[:view_context]
      heading
      loan_details
      transaction_details
    end

    private

    def price(number)
      view_context.number_to_currency(number, unit: 'P ')
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
        icon "<icon size='10'>fas-user</icon>  #{loan.borrower_name.upcase}", size: 10, inline_format: true, style: :bold
        move_down 2
        icon "<icon size='10'>fa-map-marker</icon>  #{loan.borrower_current_address_complete_address}", inline_format: true, size: 10
        move_down 2
        icon "<icon size='10'>fa-mobile</icon>  #{loan.borrower_current_contact_number}", inline_format: true, size: 10
      end
      move_down 20
      stroke do
        stroke_color 'CCCCCC'
        line_width 0.5
        stroke_horizontal_rule
        move_down 10
      end
    end

    def loan_details
      table([['Borrower', loan.borrower_name.to_s]], cell_style: { padding: [0, 0, 0, 0], inline_format: true, size: 10 }, column_widths: [120, 200]) do
        cells.borders = []
      end
      table([['Loan Product', loan.loan_product_name.to_s]], cell_style: { padding: [0, 0, 0, 0], inline_format: true, size: 10 }, column_widths: [120, 200]) do
        cells.borders = []
      end
      table([['Last Transaction', loan.last_transaction_date.strftime('%B %e, %Y').to_s]], cell_style: { padding: [0, 0, 0, 0], inline_format: true, size: 10 }, column_widths: [120, 200]) do
        cells.borders = []
      end
      bounding_box [270, 690], width: 400 do
        text 'PRINCIPAL BALANCE', size: 8
        move_down 5
        text price(loan.principal_balance).to_s, size: 18
      end
      move_down 20
      stroke do
        stroke_color 'CCCCCC'
        line_width 0.5
        stroke_horizontal_rule
      end
    end

    def transaction_details
      move_down 10
      text 'PAYMENTS HISTORY', size: 10, style: :bold
      move_down 5
      table(transactions_data, cell_style: { inline_format: true, size: 9, padding: [2, 5, 2, 5] }, column_widths: [70, 60, 70, 70, 70, 90]) do
        column(2).align = :right
        column(3).align = :right
        column(4).align = :right
        column(5).align = :right
        row(0).font_style = :bold
      end
    end

    def transactions_data
      [['DATE', ' REF #', 'PRINCIPAL', 'INTEREST', 'PENALTY', 'TOTAL', "PRINCIPAL
         BALANCE"]] +
        [['', '', '', '', '', '', price(loan.loan_amount).to_s]] +
        @transactions_data ||= loan.entries.order(entry_date: :asc).uniq.map { |entry|
          [entry.entry_date.strftime('%b %e, %Y'),
           entry.reference_number,
           price(LoansModule::Payments::Classifier.new(loan: loan, entry: entry).principal),
           price(LoansModule::Payments::Classifier.new(loan: loan, entry: entry).interest),
           price(LoansModule::Payments::Classifier.new(loan: loan, entry: entry).penalty),
           price(LoansModule::Payments::Classifier.new(loan: loan, entry: entry).total_cash_payment),
           price(loan.principal_balance(to_date: entry.entry_date, to_time: entry.entry_time))]
        }
    end
  end
end
