
module CashBooks
  class DailyTransactionPdf < Prawn::Document
    attr_reader :cash_account, :from_date, :to_date, :cooperative, :view_context, :employee, :credit_entries, :debit_entries, :entries
    def initialize(cash_account:, view_context:, from_date:, to_date:, employee:)
      super(margin: 30, page_size: "A4", page_layout: :portrait)
      @cash_account   = cash_account
      @view_context   = view_context
      @from_date      = from_date
      @to_date        = to_date
      @employee       = employee
      @cooperative    = @employee.cooperative
      @debit_entries  = @cash_account.debit_entries.entered_on(from_date: @from_date, to_date: @to_date).not_cancelled
      @credit_entries = @cash_account.credit_entries.entered_on(from_date: @from_date, to_date: @to_date).not_cancelled
      @entries        = @cash_account.entries.entered_on(from_date: @from_date, to_date: @to_date).not_cancelled

      heading
      debit_entries_table
      credit_entries_table
      summary_table
    end 

    private 

    def price(number)
      view_context.number_to_currency(number, :unit => "P ")
    end

    def heading
      bounding_box [300, 770], width: 50 do
        image "#{Rails.root}/app/assets/images/#{cooperative.abbreviated_name.downcase}_logo.jpg", width: 50, height: 50
      end
      bounding_box [360, 770], width: 200 do
        text "#{cooperative.abbreviated_name }", style: :bold, size: 20
        text "#{cooperative.name.try(:upcase)}", size: 8
        text "#{cooperative.address}", size: 8
      end
      bounding_box [0, 770], width: 400 do
        text "Daily Transaction Report", style: :bold, size: 14
        move_down 5
        table([["Employee:", "#{employee.first_middle_and_last_name}"]], 
          cell_style: {padding: [0,0,1,0], inline_format: true, size: 10}, 
          column_widths: [50, 150]) do
          cells.borders = []
          column(1).font_style = :bold
        end
        table([[{content: "#{from_date.strftime("%b. %e, %Y")} - #{to_date.strftime("%b. %e, %Y")}", colspan: 2}]], 
          cell_style: {padding: [0,0,1,0], inline_format: true, size: 10}, 
          column_widths: [50, 150]) do
          cells.borders = []
          column(1).font_style = :bold
        end
      end

      move_down 10
      stroke do
        stroke_color '24292E'
        line_width 1
        stroke_horizontal_rule
        move_down 5
      end
    end 

    def entries_table_header
      table([["POSTING DATE", "TIME", "MEMBER/PAYEE", 'DESCRIPTION', "REF. NO.", "AMOUNT"]], 
        cell_style: { inline_format: true, size: 7, font: "Helvetica", padding: [4,2,4,2]}, 
        column_widths: [100, 60, 100, 135, 50, 80]) do
        row(0).font_style= :bold
        row(0).background_color = 'DDDDDD'
        column(4).align = :right
        column(5).align = :right
        column(2).align = :left
        column(1).align = :left
      end
    end

    def debit_entries_table
      if !debit_entries.any?
        move_down 10
        text "No cash receipts data."
      else
        text "Cash Receipts"
        entries_table_header

        debit_entries_data ||= debit_entries.sort_by{|e| e.reference_number.to_i}.map do |entry|
          [
            entry.entry_date.strftime("%D"), 
            entry.entry_time.strftime("%-l:%M %p"),
            entry.display_commercial_document.upcase,
            entry.description,
            entry.reference_number,
            price(entry.debit_amounts.where(account: cash_account).total)
          ] 
        end
        table(debit_entries_data + [["TOTAL", "", "", "", "",  price(debit_entries.map{|a| a.amounts.where(account: cash_account).total}.sum)]], 
          cell_style: { inline_format: true, size: 8, padding: [1,5,3,2]}, 
          column_widths: [100, 60, 100, 135, 50, 80]) do
          column(4).align = :right
          column(5).align = :right
          row(-1).font_style = :bold
        end
      end

      def credit_entries_table
        move_down 10

        if !credit_entries.any?
          text "No cash disbursements data."
        else
          text "Cash Disbursements"
          entries_table_header
  
          credit_entries_data ||= credit_entries.sort_by{|e| e.reference_number.to_i}.map do |entry|
            [
              entry.entry_date.strftime("%D"), 
              entry.entry_time.strftime("%-l:%M %p"),
              entry.display_commercial_document.upcase,
              entry.description,
              entry.reference_number,
              price(entry.credit_amounts.where(account: cash_account).total)
            ] 
          end
          table(credit_entries_data + [["TOTAL", "", "", "", "",  price(credit_entries.map{|a| a.credit_amounts.where(account: cash_account).total}.sum)]], 
            cell_style: { inline_format: true, size: 8, padding: [1,5,3,2]}, 
            column_widths: [100, 60, 100, 135, 50, 80]) do
            column(4).align = :right
            column(5).align = :right
            row(-1).font_style = :bold
          end
        end
      end

      def summary_table
        move_down 10
        text 'ACCOUNTS SUMMARY'
        l1_categories = entries.accounts.pluck(:level_one_account_category_id)
        total_credits = BigDecimal('0')
        total_debits  = BigDecimal('0')

        account_categories_data ||= employee.office.level_one_account_categories.where(id: l1_categories.uniq.compact.flatten).map do |l1_category|
          debits_balance  = l1_category.debit_amounts.where(entry_id: entries.ids).total
          credits_balance = l1_category.credit_amounts.where(entry_id: entries.ids).total
          total_credits += credits_balance
          total_debits  += debits_balance
          [
            price(debits_balance),
            l1_category.title,
            price(credits_balance)
            # l1_category.credit_amounts.not_cancelled.where(entry_id: entries.ids).uniq.sum(&:amount)
          ]
      
        end
        table([["DEBIT", "ACCOUNT", "CREDIT"]] + account_categories_data + [[price(total_debits), "", price(total_credits)]],
          cell_style: { inline_format: true, size: 10, padding: [1,5,3,2]}, 
            column_widths: [150, 200, 150]) do
            column(0).align = :right
            column(2).align = :right
            row(-1).font_style = :bold
            end
      end
    end 
  end 
end 

