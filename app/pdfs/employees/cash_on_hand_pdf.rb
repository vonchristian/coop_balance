module Employees
  class CashOnHandPdf < Prawn::Document
    attr_reader :entries, :employee, :from_date, :to_date, :title, :view_context, :cooperative

    def initialize(entries, employee, from_date, to_date, title, view_context)
      super(margin: 20, page_size: 'A4', page_layout: :portrait)
      @entries = entries
      @employee = employee
      @cooperative = @employee.cooperative
      @from_date = from_date
      @to_date = to_date
      @title = title
      @view_context = view_context
      heading
      account_details
      sundries_summary
      entries_table
    end

    private

    def price(number)
      view_context.number_to_currency(number, unit: 'P ')
    end

    def display_commercial_document_for(entry)
      if entry.commercial_document.try(:member).present?
        entry.commercial_document.try(:member).try(:full_name)
      elsif entry.commercial_document.try(:depositor).present?
        entry.commercial_document.try(:depositor).try(:full_name)
      elsif entry.commercial_document.try(:borrower).present?
        entry.commercial_document.try(:borrower).try(:full_name)
      else
        entry.description
      end
    end

    def heading
      bounding_box [300, 800], width: 50 do
        image Rails.root.join('app/assets/images/kccmc_logo.jpg').to_s, width: 50, height: 50
      end
      bounding_box [370, 800], width: 200 do
        text cooperative.abbreviated_name.to_s, style: :bold, size: 24
        text cooperative.name.to_s, size: 10
      end
      bounding_box [0, 800], width: 400 do
        text title.to_s, style: :bold, size: 12
        move_down 3
        text "#{from_date.strftime('%B %e, %Y')} To #{to_date.strftime('%B %e, %Y')} ", size: 10
        move_down 3

        text "Employee: #{employee.name}", size: 10
      end
      move_down 15
      stroke do
        stroke_color '24292E'
        line_width 1
        stroke_horizontal_rule
        move_down 20
      end
    end

    def account_details
      text 'CASH ON HAND DETAILS', size: 10, style: :bold
      table(accounts_data, cell_style: { inline_format: true, size: 10, font: 'Helvetica', padding: [2, 0, 5, 0] }, column_widths: [20, 150, 150]) do
        cells.borders = []
        column(2).align = :right
      end
      move_down 10
      stroke do
        stroke_color 'CCCCCC'
        line_width 0.2
        stroke_horizontal_rule
        move_down 10
      end
    end

    def accounts_data
      [['', 'Account', employee.cash_on_hand_account.try(:name).to_s]] +
        [['', 'Transactions Count ', entries.count.to_s]] +
        [['', 'Start Date', from_date.strftime('%B %e, %Y').to_s]] +
        [['', 'End Date', to_date.strftime('%B %e, %Y').to_s]] +
        [['', 'Beginning Balance',  price(employee.cash_on_hand_account.balance(to_date: from_date.yesterday.end_of_day)).to_s]] +
        [['', 'Cash Disbursements', price(employee.cash_on_hand_account.credits_balance(from_date: from_date.beginning_of_day, to_date: to_date.end_of_day)).to_s]] +
        [['', 'Cash Receipts', price(employee.cash_on_hand_account.debits_balance(from_date: from_date.beginning_of_day, to_date: to_date.end_of_day)).to_s]] +
        [['', 'Ending Balance', price(employee.cash_on_hand_account.balance(to_date: to_date.end_of_day)).to_s]]
    end

    def sundries_summary
      text 'SUMMARY OF ACCOUNTS', style: :bold, size: 10

      table(sundries_summary_data, cell_style: { inline_format: true, size: 10, font: 'Helvetica' }, column_widths: [20, 80, 200, 150, 100]) do
        cells.borders = []
        row(0).font_style = :bold
        column(3).align = :right
        column(4).align = :right
      end
    end

    def sundries_summary_data
      [['', 'Code', 'Account Title ', 'Debits', 'Credits']] +
        @sundries_summary_data ||= AccountingModule::Account.updated_at(from_date: from_date.beginning_of_day, to_date: to_date.end_of_day).updated_by(employee).uniq.map { |a| ['', a.code, a.name, price(a.debits_balance(from_date: from_date.beginning_of_day, to_date: to_date.end_of_day)), price(a.credits_balance(from_date: from_date.beginning_of_day, to_date: to_date.end_of_day))] } +
                                   [['', '', '<b>TOTAL</b>',
                                     "<b>#{price(AccountingModule::Account.updated_at(from_date: from_date.beginning_of_day, to_date: to_date.end_of_day).updated_by(employee).uniq.sum { |a| a.debits_balance(to_date: to_date.end_of_day) })}</b>",
                                     "<b>#{price(AccountingModule::Account.updated_at(from_date: from_date.beginning_of_day, to_date: to_date.end_of_day).updated_by(employee).uniq.sum { |a| a.credits_balance(to_date: to_date.end_of_day) })}</b>"]]
    end

    def entries_table
      move_down 10
      if entries.none?
        text 'No entries data.', align: :center
      else
        stroke do
          stroke_color 'CCCCCC'
          line_width 0.2
          stroke_horizontal_rule
          move_down 15
        end
        text 'TRANSACTION DETAILS:', size: 10, style: :bold
        move_down 5
        table([['DATE', 'DESCRIPTION', 'REFERENCE NUMBER', 'PARTICULAR/PAYEE', 'EMPLOYEE', 'ACCOUNT', 'AMOUNT']], cell_style: { inline_format: true, size: 6, font: 'Helvetica' }, column_widths: [50, 100, 50, 100, 50, 120, 80]) do
          cells.borders = []
          row(0).font_style = :bold
          row(0).background_color = 'DDDDDD'
          column(-1).align = :right
        end
        entries.uniq.each do |entry|
          table([[entry.entry_date.strftime('%b %e, %Y').to_s, entry.description.to_s, entry.reference_number.to_s, display_commercial_document_for(entry).try(:upcase).to_s, entry.recorder.try(:first_and_last_name).try(:upcase).to_s]], cell_style: { size: 8, padding: [5, 5, 4, 0] }, column_widths: [50, 100, 50, 100, 50, 120, 80]) do
            cells.borders = []
          end

          table([['', '', '', '', '', '<b>DEBIT</b>']] +
            entry.debit_amounts.map { |a| ['', '', '', '', '', a.account.name, price(a.amount)] }, column_widths: [50, 100, 50, 100, 50, 120, 80], cell_style: { inline_format: true, size: 8, padding: [0, 0, 0, 0] }) do
            cells.borders = []
            column(-1).align = :right
          end

          table([['', '', '', '', '', '<b>CREDIT</b>']] + entry.credit_amounts.map { |a| ['', '', '', '', '', a.account.name, price(a.amount)] }, column_widths: [50, 100, 50, 100, 50, 120, 80], cell_style: { inline_format: true, padding: [0, 0, 2, 0], size: 8 }) do
            cells.borders = []
            column(-1).align = :right
          end
          stroke do
            stroke_color 'CCCCCC'
            line_width 0.2
            stroke_horizontal_rule
          end
        end

      end
    end
  end
end
