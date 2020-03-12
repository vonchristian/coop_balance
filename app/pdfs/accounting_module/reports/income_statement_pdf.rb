module AccountingModule
  module Reports
    class IncomeStatementPdf < Prawn::Document
      attr_reader :view_context, :from_date, :to_date, :cooperative, :office,
      :level_three_revenue_account_categories, 
      :level_two_revenue_account_categories, 
      :level_one_revenue_account_categories,
      :level_three_expense_account_categories, 
      :level_two_expense_account_categories, 
      :level_one_expense_account_categories

      def initialize(args={})
        super(margin: 40, page_size: [612, 988], page_layout: :portrait)
        @to_date      = args[:to_date]
        @from_date    = args[:from_date]
        @view_context = args[:view_context]
        @cooperative  = args[:cooperative]
        @office       = args[:office]

        @level_three_revenue_account_categories = args[:level_three_revenue_account_categories] || @office.level_three_account_categories.revenues
        @level_two_revenue_account_categories   = args[:level_two_revenue_account_categories]   || @office.level_two_account_categories.revenues
        @level_one_revenue_account_categories   = args[:level_one_revenue_account_categories]   || @office.level_one_account_categories.revenues.where.not(id: @office.current_net_income_config.total_revenue_account.level_one_account_category)
        @level_three_expense_account_categories = args[:level_three_expense_account_categories] || @office.level_three_account_categories.expenses
        @level_two_expense_account_categories   = args[:level_two_expense_account_categories]   || @office.level_two_account_categories.expenses
        @level_one_expense_account_categories   = args[:level_one_expense_account_categories]   || @office.level_one_account_categories.expenses.where.not(id: @office.current_net_income_config.total_expense_account.level_one_account_category)
        
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
          text "Date Covered: #{@from_date.strftime("%B %e, %Y")} - #{to_date.strftime("%b. %e, %Y")} ",  size: 10
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

      def all_level_one_revenue_account_categories
        ids = []
        level_three_revenue_account_categories.level_two_account_categories.revenues.each do |l2_account_category|
          ids << l2_account_category.level_one_account_categories.revenues.pluck(:id)
        end 
        level_two_revenue_account_categories.each do |l2_account_category|
          ids << l2_account_category.level_one_account_categories.revenues.pluck(:id)
        end 
        ids << level_one_revenue_account_categories.ids 
        
        AccountingModule::LevelOneAccountCategory.revenues.where(id: ids.uniq.compact.flatten)
      end 

      def all_level_one_expense_account_categories
        ids = []
        level_three_expense_account_categories.level_two_account_categories.expenses.each do |l2_account_category|
          ids << l2_account_category.level_one_account_categories.expenses.pluck(:id)
        end 
        level_two_expense_account_categories.each do |l2_account_category|
          ids << l2_account_category.level_one_account_categories.expenses.pluck(:id)
        end 
        ids << level_one_expense_account_categories.ids 
        
        AccountingModule::LevelOneAccountCategory.expenses.where(id: ids.uniq.compact.flatten)
      end

      def revenues_table
        table([["REVENUES"]], cell_style: {padding: [2,2], inline_format: true, size: 10}, column_widths: [230, 100]) do
          cells.borders = []
          column(0).font_style = :bold
        end

        level_three_revenue_account_categories.order(code: :asc).each do |l3_account_category|
          if l3_account_category.show_sub_categories?
            table([["#{l3_account_category.title}"]], cell_style: { padding: [2,2], inline_format: true, size: 10}, column_widths: [320, 100]) do
              cells.borders = []
              column(2).align = :right
            end
            l3_account_category.level_two_account_categories.each do |l2_account_category|
              if l2_account_category.show_sub_categories?
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
              else 
                table([["", "#{l2_account_category.title}",price(l2_account_category.balance(from_date: @from_date, to_date: @to_date)) ]], cell_style: { padding: [2, 2], inline_format: true, size: 10}, column_widths: [10, 320, 100]) do
                  cells.borders = []
                  column(2).align = :right
                  row(-1).font_style = :bold
                end
              end
            end 
            stroke_horizontal_rule
            table([["Total #{l3_account_category.title}",price(l3_account_category.balance(from_date: @from_date, to_date: @to_date)) ]], cell_style: { padding: [2, 2], inline_format: true, size: 10}, column_widths: [330, 100]) do
              cells.borders = []
              column(1).align = :right
              row(-1).font_style = :bold
            end
          else 
            table([["#{l3_account_category.title}",price(l3_account_category.balance(from_date: @from_date, to_date: @to_date)) ]], cell_style: { padding: [2, 2], inline_format: true, size: 10}, column_widths: [330, 100]) do
              cells.borders = []
              column(1).align = :right
              row(-1).font_style = :bold
            end
          end 
        end
        stroke_horizontal_rule
        level_two_revenue_account_categories.where.not(id: level_three_revenue_account_categories.level_two_account_categories.revenues.ids).each do |l2_account_category|
          if l2_account_category.show_sub_categories?
            table([["", "#{l2_account_category.title}",price(l2_account_category.balance(from_date: @from_date, to_date: @to_date)) ]], cell_style: { padding: [2, 2], inline_format: true, size: 10}, column_widths: [10, 320, 100]) do
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
          else 
            table([["", " #{l2_account_category.title}",price(l2_account_category.balance(from_date: @from_date, to_date: @to_date)) ]], cell_style: { padding: [2, 2], inline_format: true, size: 10}, column_widths: [10, 320, 100]) do
              cells.borders = []
              column(2).align = :right
              row(-1).font_style = :bold
            end
          end
        end 
        level_one_revenue_account_categories.
        where.not(id: level_two_revenue_account_categories.level_one_account_categories.revenues.ids).
        where.not(id: office.current_net_income_config.total_revenue_account.level_one_account_category_id).
        each do |l1_account_category|
          table([["", "", "#{l1_account_category.title}", price(l1_account_category.balance(from_date: @from_date, to_date: @to_date))]], cell_style: { padding: [2,2], inline_format: true, size: 10}, column_widths: [10, 10, 310, 100]) do
            cells.borders = []
            column(3).align = :right
          end
        end

        stroke_horizontal_rule
        move_down 5

        table([["TOTAL REVENUES", price(office.current_net_income_config.total_revenues(from_date: from_date, to_date: to_date).abs)]], cell_style: {padding: [2,2], inline_format: true, size: 10},
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

        level_three_expense_account_categories.order(code: :asc).each do |l3_account_category|
          if l3_account_category.show_sub_categories?
            table([["#{l3_account_category.title}"]], cell_style: { padding: [2,2], inline_format: true, size: 10}, column_widths: [320, 100]) do
              cells.borders = []
              column(2).align = :right
            end
            l3_account_category.level_two_account_categories.each do |l2_account_category|
              if l2_account_category.show_sub_categories?
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
              else 
                table([["", "#{l2_account_category.title}",price(l2_account_category.balance(from_date: @from_date, to_date: @to_date)) ]], cell_style: { padding: [2, 2], inline_format: true, size: 10}, column_widths: [10, 320, 100]) do
                  cells.borders = []
                  column(2).align = :right
                  row(-1).font_style = :bold
                end
              end
            end 
            stroke_horizontal_rule
            table([["Total #{l3_account_category.title}",price(l3_account_category.balance(from_date: @from_date, to_date: @to_date)) ]], cell_style: { padding: [2, 2], inline_format: true, size: 10}, column_widths: [330, 100]) do
              cells.borders = []
              column(1).align = :right
              row(-1).font_style = :bold
            end
          else 
            table([["#{l3_account_category.title}",price(l3_account_category.balance(from_date: @from_date, to_date: @to_date)) ]], cell_style: { padding: [2, 2], inline_format: true, size: 10}, column_widths: [330, 100]) do
              cells.borders = []
              column(1).align = :right
              row(-1).font_style = :bold
            end
          end 
        end
        stroke_horizontal_rule
        level_two_expense_account_categories.where.not(id: level_three_expense_account_categories.level_two_account_categories.expenses.ids).each do |l2_account_category|
          if l2_account_category.show_sub_categories?
            table([["", "#{l2_account_category.title}",price(l2_account_category.balance(from_date: @from_date, to_date: @to_date)) ]], cell_style: { padding: [2, 2], inline_format: true, size: 10}, column_widths: [10, 320, 100]) do
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
          else 
            table([["", " #{l2_account_category.title}",price(l2_account_category.balance(from_date: @from_date, to_date: @to_date)) ]], cell_style: { padding: [2, 2], inline_format: true, size: 10}, column_widths: [10, 320, 100]) do
              cells.borders = []
              column(2).align = :right
              row(-1).font_style = :bold
            end
          end
        end 

        level_one_expense_account_categories.
        where.not(id: level_two_expense_account_categories.level_one_account_categories.expenses.ids).
        where.not(id: office.current_net_income_config.total_expense_account.level_one_account_category_id).
        each do |l1_account_category|
          table([["", "", "#{l1_account_category.title}", price(l1_account_category.balance(from_date: @from_date, to_date: @to_date))]], cell_style: { padding: [2,2], inline_format: true, size: 10}, column_widths: [10, 10, 310, 100]) do
            cells.borders = []
            column(3).align = :right
          end
        end

        stroke_horizontal_rule
        move_down 5

        table([["TOTAL EXPENSES", price(office.current_net_income_config.total_expenses(from_date: @from_date, to_date: @to_date).abs)]], cell_style: {padding: [2,2], inline_format: true, size: 10},
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
        table([["NET SURPLUS", price(office.current_net_income_config.total_net_surplus(from_date: @from_date, to_date: @to_date))]], cell_style: {padding: [2,2], inline_format: true, size: 10},
          column_widths: [330, 100]) do
            cells.borders = []
            column(0).font_style = :bold
            column(1).align = :right
            column(1).font_style = :bold
            row(-1).font_size = 14
          end
        end
    end
  end
end
