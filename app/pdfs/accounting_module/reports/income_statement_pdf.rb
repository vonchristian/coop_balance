module AccountingModule
  module Reports
    class IncomeStatementPdf < Prawn::Document
      attr_reader :view_context, :to_date, :cooperative, :office, :from_date
      def initialize(args={})
        super(margin: 40, page_size: [612, 988], page_layout: :portrait)
        @from_date    = args[:from_date]
        @to_date      = args[:to_date]
        @view_context = args[:view_context]
        @cooperative  = args[:cooperative]
        @office       = args[:office]
        heading
        revenues_table
        expenses_table
        net_surplus_table
      end

      private
      def price(number)
        view_context.number_to_currency(number, :unit => "P ")
      end

      def heading
        bounding_box [300, 920], width: 50 do
          image "#{Rails.root}/app/assets/images/#{cooperative.abbreviated_name.downcase}_logo.jpg", width: 50, height: 50
        end

        bounding_box [360, 920], width: 200 do
          text "#{cooperative.abbreviated_name }", style: :bold, size: 20
          text "#{cooperative.name.try(:upcase)}", size: 8
          text "#{cooperative.address}", size: 8
        end

        bounding_box [0, 920], width: 400 do
          text "INCOME STATEMENT",  size: 14, style: :bold
          text "Date Covered: #{from_date.strftime("%b. %e, %Y")} - #{to_date.strftime("%b. %e, %Y")} ",  size: 10
          text "Office: #{office.name}", size: 10
        end

        move_down 30
        stroke do
          stroke_color '24292E'
          line_width 1
          stroke_horizontal_rule
          move_down 5
        end
      end

      def revenues_table
        table([["REVENUES"]], cell_style: {padding: [2,2], inline_format: true, size: 10}, column_widths: [230, 100]) do
          cells.borders = []
          column(0).font_style = :bold
        end

        office.level_three_account_categories.revenues.order(code: :asc).each do |l3_account_category|
          table([["#{l3_account_category.title}"]], cell_style: {padding: [2,2], inline_format: true, size: 10}, column_widths: [230, 100]) do
            cells.borders = []
          end

          l3_account_category.level_two_account_categories.each do |l2_account_category|
            table([["","#{l2_account_category.title}"]], cell_style: { padding: [2,2], inline_format: true, size: 10}, column_widths: [10, 320, 100]) do
              cells.borders = []
              column(2).align = :right
            end

            l2_account_category.level_one_account_categories.each do |l1_account_category|
              table([["", "", "#{l1_account_category.title}", price(l1_account_category.balance(from_date: @from_date, to_date: @to_date))]], cell_style: { padding: [2,2], inline_format: true, size: 10}, column_widths: [10, 10, 310, 100]) do
                cells.borders = []
                column(3).align = :right
              end
              stroke_horizontal_rule

              table([["", "Total #{l2_account_category.title}",price(l2_account_category.balance(from_date: @from_date, to_date: @to_date)) ]], cell_style: { padding: [2, 2], inline_format: true, size: 10}, column_widths: [10, 320, 100]) do
                cells.borders = []
                column(2).align = :right
                row(-1).font_style = :bold
              end
            end

            stroke_horizontal_rule
            table([["Total #{l3_account_category.title}",price(l2_account_category.balance(from_date: @from_date, to_date: @to_date)) ]], cell_style: { padding: [2, 2], inline_format: true, size: 10}, column_widths: [330, 100]) do
              cells.borders = []
              column(1).align = :right
              row(-1).font_style = :bold
            end

          end
        end

        stroke_horizontal_rule
        office.level_two_account_categories.revenues.where.not(id: office.level_three_account_categories.level_two_account_categories.ids).each do |l2_account_category|
          table([["","#{l2_account_category.title}"]], cell_style: { padding: [2,2], inline_format: true, size: 10}, column_widths: [10, 320, 100]) do
            cells.borders = []
            column(2).align = :right
          end
          l2_account_category.level_one_account_categories.each do |l1_account_category|
            table([["", "", "#{l1_account_category.title}", price(l1_account_category.balance(from_date: @from_date, to_date: @to_date))]], cell_style: { padding: [2,2], inline_format: true, size: 10}, column_widths: [10, 10, 310, 100]) do
              cells.borders = []
              column(3).align = :right
            end
          end
          stroke_horizontal_rule

          table([["", "Total #{l2_account_category.title}",price(l2_account_category.balance(from_date: @from_date, to_date: @to_date)) ]], cell_style: { padding: [2, 2], inline_format: true, size: 10}, column_widths: [10, 320, 100]) do
            cells.borders = []
            column(2).align = :right
            row(-1).font_style = :bold
          end
        end
        office.level_one_account_categories.revenues.where.not(id: office.level_two_account_categories.level_one_account_categories.ids).each do |l1_account_category|
          table([["", "", "#{l1_account_category.title}", price(l1_account_category.balance(from_date: @from_date, to_date: @to_date))]], cell_style: { padding: [2,2], inline_format: true, size: 10}, column_widths: [10, 10, 310, 100]) do
            cells.borders = []
            column(3).align = :right
          end
        end

        stroke_horizontal_rule
        move_down 5

        table([["TOTAL REVENUES", price(office.level_one_account_categories.revenues.balance(from_date: @from_date, to_date: @to_date))]], cell_style: {padding: [2,2], inline_format: true, size: 10},
          column_widths: [330, 100]) do
            cells.borders = []
            column(0).font_style = :bold
            column(1).align = :right
            column(1).font_style = :bold
            row(-1).font_size = 14

          end
        move_down 10
      end

      def expenses_table
        table([["EXPENSES"]], cell_style: {padding: [2,2], inline_format: true, size: 10}, column_widths: [230, 100]) do
          cells.borders = []
          column(0).font_style = :bold
        end

        office.level_three_account_categories.expenses.order(code: :asc).each do |l3_account_category|
          table([["#{l3_account_category.title}"]], cell_style: {padding: [2,2], inline_format: true, size: 10}, column_widths: [230, 100]) do
            cells.borders = []
          end

          l3_account_category.level_two_account_categories.each do |l2_account_category|
            table([["","#{l2_account_category.title}"]], cell_style: { padding: [2,2], inline_format: true, size: 10}, column_widths: [10, 320, 100]) do
              cells.borders = []
              column(2).align = :right
            end

            l2_account_category.level_one_account_categories.each do |l1_account_category|
              table([["", "", "#{l1_account_category.title}", price(l1_account_category.balance(from_date: @from_date, to_date: @to_date))]], cell_style: { padding: [2,2], inline_format: true, size: 10}, column_widths: [10, 10, 310, 100]) do
                cells.borders = []
                column(3).align = :right
              end
              stroke_horizontal_rule

              table([["", "Total #{l2_account_category.title}",price(l2_account_category.balance(from_date: @from_date, to_date: @to_date)) ]], cell_style: { padding: [2, 2], inline_format: true, size: 10}, column_widths: [10, 320, 100]) do
                cells.borders = []
                column(2).align = :right
                row(-1).font_style = :bold
              end
            end

            stroke_horizontal_rule
            table([["Total #{l3_account_category.title}",price(l2_account_category.balance(from_date: @from_date, to_date: @to_date)) ]], cell_style: { padding: [2, 2], inline_format: true, size: 10}, column_widths: [330, 100]) do
              cells.borders = []
              column(1).align = :right
              row(-1).font_style = :bold
            end

          end
        end

        stroke_horizontal_rule
        office.level_two_account_categories.expenses.where.not(id: office.level_three_account_categories.expenses.level_two_account_categories.expenses.ids).each do |l2_account_category|
          table([["","#{l2_account_category.title}"]], cell_style: { padding: [2,2], inline_format: true, size: 10}, column_widths: [10, 320, 100]) do
            cells.borders = []
            column(2).align = :right
          end
          l2_account_category.level_one_account_categories.each do |l1_account_category|
            table([["", "", "#{l1_account_category.title}", price(l1_account_category.balance(from_date: @from_date, to_date: @to_date))]], cell_style: { padding: [2,2], inline_format: true, size: 10}, column_widths: [10, 10, 310, 100]) do
              cells.borders = []
              column(3).align = :right
            end
          end
          stroke_horizontal_rule

          table([["", "Total #{l2_account_category.title}",price(l2_account_category.balance(from_date: @from_date, to_date: @to_date)) ]], cell_style: { padding: [2, 2], inline_format: true, size: 10}, column_widths: [10, 320, 100]) do
            cells.borders = []
            column(2).align = :right
            row(-1).font_style = :bold
          end
        end
        office.level_one_account_categories.expenses.where.not(id: office.level_two_account_categories.level_one_account_categories.ids).each do |l1_account_category|
          table([["", "", "#{l1_account_category.title}", price(l1_account_category.balance(from_date: @from_date, to_date: @to_date))]], cell_style: { padding: [2,2], inline_format: true, size: 10}, column_widths: [10, 10, 310, 100]) do
            cells.borders = []
            column(3).align = :right
          end
        end

        stroke_horizontal_rule
        move_down 5

        table([["TOTAL EXPENSES", price(office.level_one_account_categories.expenses.balance(from_date: @from_date, to_date: @to_date))]], cell_style: {padding: [2,2], inline_format: true, size: 10},
          column_widths: [330, 100]) do
            cells.borders = []
            column(0).font_style = :bold
            column(1).align = :right
            column(1).font_style = :bold
            row(-1).font_size = 14

          end
        move_down 10
      end

      def net_surplus_table
        table([["NET SURPLUS/LOSS", price(office.level_one_account_categories.revenues.balance(from_date: @from_date, to_date: @to_date) - office.level_one_account_categories.expenses.balance(from_date: @from_date, to_date: @to_date))]], cell_style: {padding: [2,2], inline_format: true, size: 10}, column_widths: [330, 100]) do
          cells.borders = []
          column(0).font_style = :bold
          column(1).align = :right
          column(1).font_style = :bold
        end
      end
    end
    end
  end
