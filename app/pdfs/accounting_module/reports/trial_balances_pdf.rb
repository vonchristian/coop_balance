module AccountingModule
  module Reports
    class TrialBalancesPdf < Prawn::Document
      def initialize(accounts, to_date, view_context)
        super(margin: 40, page_size: "A4", page_layout: :portrait)
        @accounts = accounts
        @to_date = to_date
        @view_context = view_context
        heading
        accounts_table
      end

      private
      def price(number)
        @view_context.number_to_currency(number, :unit => "P ")
      end

      def heading
        bounding_box [300, 780], width: 50 do
          image "#{Rails.root}/app/assets/images/logo_kcmdc.jpg", width: 50, height: 50
        end
        bounding_box [370, 780], width: 200 do
            text "KCMDC", style: :bold, size: 24
            text "Kiangan Community Multipurpose Cooperative", size: 10
        end
        bounding_box [0, 780], width: 400 do
          text "Trial Balances Report", style: :bold, size: 14
          move_down 3
          text "#{@to_date.strftime("%B %e, %Y")}", size: 10
          move_down 3
          text "Date Generated: #{Time.zone.now.strftime("%B %e, %Y %H:%M %p")}", size: 8
          move_down 3

          # text "Employee: #{@employee.name}", size: 10
        end
        move_down 15
        stroke do
          stroke_color '24292E'
          line_width 1
          stroke_horizontal_rule
          move_down 20
        end
      end
      def accounts_table
      text "ACCOUNTS", style: :bold, size: 10
      move_down 5
      table(accounts_data, cell_style: { inline_format: true, size: 8, font: "Helvetica", :padding => [2,5,2,5]}, column_widths: [45, 150, 80, 80, 80, 80]) do
        row(0).font_style= :bold
        row(0).background_color = 'DDDDDD'

        column(2).align = :right
        column(3).align = :right
        column(4).align = :right
        column(5).align = :right

      end
    end
    def accounts_data
      [["Code", "Account Name", "Beginning Balance", "Debit", "Credit", "Ending Balance"]] +
      @accounts_data ||= AccountingModule::Account.updated_at(from_date: @to_date, to_date: @to_date).uniq.map{|a| [a.code, a.name, price(a.balance(to_date: @to_date.yesterday.end_of_day)), price(a.debits_balance(to_date: @to_date)), price(a.credits_balance(to_date: @to_date)), price(a.balance(to_date: @to_date))] }
    end
    end
  end
end
