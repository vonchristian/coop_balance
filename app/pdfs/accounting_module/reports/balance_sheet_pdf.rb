module AccountingModule
  module Reports
    class BalanceSheetPdf < Prawn::Document
      attr_reader :view_context, :to_date, :cooperative, :office, :from_date, :title,
      :level_three_asset_account_categories, 
      :level_two_asset_account_categories, 
      :level_one_asset_account_categories,

      :level_three_liability_account_categories, 
      :level_two_liability_account_categories, 
      :level_one_liability_account_categories,

      :level_three_equity_account_categories, 
      :level_two_equity_account_categories, 
      :level_one_equity_account_categories

      def initialize(args={})
        super(margin: 40, page_size: [612, 988], page_layout: :portrait)
        @to_date      = args[:to_date]
        @from_date    = args[:to_date].beginning_of_year
        @view_context = args[:view_context]
        @cooperative  = args[:cooperative]
        @office       = args[:office]
        @title        = args[:title] || "Balance Sheet"
        @level_three_asset_account_categories     = args[:level_three_asset_account_categories] || @office.level_three_account_categories.assets
        @level_two_asset_account_categories       = args[:level_two_asset_account_categories] || @office.level_two_account_categories.assets
        @level_one_asset_account_categories       = args[:level_one_asset_account_categories] || @office.level_one_account_categories.assets
        @level_three_liability_account_categories = args[:level_three_liability_account_categories] || @office.level_three_account_categories.liabilities
        @level_two_liability_account_categories   = args[:level_two_liability_account_categories] || @office.level_two_account_categories.liabilities
        @level_one_liability_account_categories   = args[:level_one_liability_account_categories] || @office.level_one_account_categories.liabilities
        @level_three_equity_account_categories    = args[:level_three_equity_account_categories] || @office.level_three_account_categories.equities
        @level_two_equity_account_categories      = args[:level_two_equity_account_categories] || @office.level_two_account_categories.equities
        @level_one_equity_account_categories      = args[:level_one_equity_account_categories] || @office.level_one_account_categories.equities
        heading
        assets_table
        liabilities_and_equities_table
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
          text "#{title}",  size: 14, style: :bold
          text "As of: #{to_date.strftime("%b. %e, %Y")} ",  size: 10
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

      def all_level_one_asset_account_categories
        ids = []
        level_three_asset_account_categories.level_two_account_categories.assets.each do |l2_account_category|
          ids << l2_account_category.level_one_account_categories.assets.pluck(:id)
        end 
        level_two_asset_account_categories.each do |l2_account_category|
          ids << l2_account_category.level_one_account_categories.assets.pluck(:id)
        end 
        ids << level_one_asset_account_categories.ids 
        
        AccountingModule::LevelOneAccountCategory.where(id: ids.uniq.compact.flatten)
      end 

      def all_level_one_liability_account_categories
        ids = []
        level_three_liability_account_categories.level_two_account_categories.liabilities.each do |l2_account_category|
          ids << l2_account_category.level_one_account_categories.liabilities.pluck(:id)
        end 
        level_two_liability_account_categories.each do |l2_account_category|
          ids << l2_account_category.level_one_account_categories.liabilities.pluck(:id)
        end 
        ids << level_one_liability_account_categories.ids 
        
        AccountingModule::LevelOneAccountCategory.where(id: ids.uniq.compact.flatten)
      end
      
      def all_level_one_equity_account_categories
        ids = []
        level_three_equity_account_categories.level_two_account_categories.equities.each do |l2_account_category|
          ids << l2_account_category.level_one_account_categories.equities.pluck(:id)
        end 
        level_two_equity_account_categories.each do |l2_account_category|
          ids << l2_account_category.level_one_account_categories.equities.pluck(:id)
        end 
        ids << level_one_equity_account_categories.ids 
        
        AccountingModule::LevelOneAccountCategory.where(id: ids.uniq.compact.flatten)
      end

      def assets_table
        table([["ASSETS"]], cell_style: {padding: [2,2], inline_format: true, size: 10}, column_widths: [230, 100]) do
          cells.borders = []
          column(0).font_style = :bold
        end

        level_three_asset_account_categories.order(code: :asc).each do |l3_account_category|
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
                  table([["", "", "#{l1_account_category.title}", price(l1_account_category.balance(to_date: @to_date))]], cell_style: { padding: [2,2], inline_format: true, size: 10}, column_widths: [10, 10, 310, 100]) do
                    cells.borders = []
                    column(3).align = :right
                  end
                end
                stroke_horizontal_rule

                table([["", "Total #{l2_account_category.title}",price(l2_account_category.balance(to_date: @to_date)) ]], cell_style: { padding: [2, 2], inline_format: true, size: 10}, column_widths: [10, 320, 100]) do
                  cells.borders = []
                  column(2).align = :right
                  row(-1).font_style = :bold
                end
              else 
                table([["", "#{l2_account_category.title}",price(l2_account_category.balance(to_date: @to_date)) ]], cell_style: { padding: [2, 2], inline_format: true, size: 10}, column_widths: [10, 320, 100]) do
                  cells.borders = []
                  column(2).align = :right
                  row(-1).font_style = :bold
                end
              end
            end 
            stroke_horizontal_rule
            table([["Total #{l3_account_category.title}",price(l3_account_category.balance(to_date: @to_date)) ]], cell_style: { padding: [2, 2], inline_format: true, size: 10}, column_widths: [330, 100]) do
              cells.borders = []
              column(1).align = :right
              row(-1).font_style = :bold
            end
          else 
            table([["#{l3_account_category.title}",price(l3_account_category.balance(to_date: @to_date)) ]], cell_style: { padding: [2, 2], inline_format: true, size: 10}, column_widths: [330, 100]) do
              cells.borders = []
              column(1).align = :right
              row(-1).font_style = :bold
            end
          end 
        end
        stroke_horizontal_rule
        level_two_asset_account_categories.where.not(id: level_three_asset_account_categories.level_two_account_categories.assets.ids).each do |l2_account_category|
          if l2_account_category.show_sub_categories?
            table([["", "#{l2_account_category.title}",price(l2_account_category.balance(to_date: @to_date)) ]], cell_style: { padding: [2, 2], inline_format: true, size: 10}, column_widths: [10, 320, 100]) do
              cells.borders = []
              column(2).align = :right
              
            end
            l2_account_category.level_one_account_categories.each do |l1_account_category|
              table([["", "", "#{l1_account_category.title}", price(l1_account_category.balance(to_date: @to_date))]], cell_style: { padding: [2,2], inline_format: true, size: 10}, column_widths: [10, 10, 310, 100]) do
                cells.borders = []
                column(3).align = :right
              end
            end
            stroke_horizontal_rule

            table([["", "Total #{l2_account_category.title}",price(l2_account_category.balance(to_date: @to_date)) ]], cell_style: { padding: [2, 2], inline_format: true, size: 10}, column_widths: [10, 320, 100]) do
              cells.borders = []
              column(2).align = :right
              row(-1).font_style = :bold
            end
          else 
            table([["", " #{l2_account_category.title}",price(l2_account_category.balance(to_date: @to_date)) ]], cell_style: { padding: [2, 2], inline_format: true, size: 10}, column_widths: [10, 320, 100]) do
              cells.borders = []
              column(2).align = :right
              row(-1).font_style = :bold
            end
          end
        end 
        level_one_asset_account_categories.where.not(id: level_two_asset_account_categories.level_one_account_categories.assets.ids).each do |l1_account_category|
          table([["", "", "#{l1_account_category.title}", price(l1_account_category.balance(to_date: @to_date))]], cell_style: { padding: [2,2], inline_format: true, size: 10}, column_widths: [10, 10, 310, 100]) do
            cells.borders = []
            column(3).align = :right
          end
        end

        stroke_horizontal_rule
        move_down 5

        table([["TOTAL ASSETS", price(all_level_one_asset_account_categories.balance(to_date: @to_date))]], cell_style: {padding: [2,2], inline_format: true, size: 10},
          column_widths: [330, 100]) do
            cells.borders = []
            column(0).font_style = :bold
            column(1).align = :right
            column(1).font_style = :bold
            row(-1).font_size = 14

          end
        move_down 10
      end

      def liabilities_and_equities_table
        move_down 5
        table([["LIABILITIES"]], cell_style: {padding: [2,2], inline_format: true, size: 10}, column_widths: [230, 100]) do
          cells.borders = []
          column(0).font_style = :bold
        end

        level_three_liability_account_categories.order(code: :asc).each do |l3_account_category|
          if l3_account_category.show_sub_categories?
            table([["#{l3_account_category.title}"]], cell_style: {padding: [2,2], inline_format: true, size: 10}, column_widths: [230, 100]) do
              cells.borders = []
            end

            l3_account_category.level_two_account_categories.each do |l2_account_category|
              table([["","#{l2_account_category.title}"]], cell_style: { padding: [2,2], inline_format: true, size: 10}, column_widths: [10, 320, 100]) do
                cells.borders = []
                column(2).align = :right
              end

              l2_account_category.level_one_account_categories.each do |l1_account_category|
                table([["", "", "#{l1_account_category.title}", price(l1_account_category.balance(to_date: @to_date))]], cell_style: { padding: [2,2], inline_format: true, size: 10}, column_widths: [10, 10, 310, 100]) do
                  cells.borders = []
                  column(3).align = :right
                end
              end
              stroke_horizontal_rule

              table([["", "Total #{l2_account_category.title}",price(l2_account_category.balance(to_date: @to_date)) ]], cell_style: { padding: [2, 2], inline_format: true, size: 10}, column_widths: [10, 320, 100]) do
                cells.borders = []
                column(2).align = :right
                row(-1).font_style = :bold
              end
            end

            stroke_horizontal_rule
            table([["Total #{l3_account_category.title}",price(l3_account_category.balance(to_date: @to_date)) ]], cell_style: { padding: [2, 2], inline_format: true, size: 10}, column_widths: [330, 100]) do
              cells.borders = []
              column(1).align = :right
              row(-1).font_style = :bold
            end
          else 
            table([["#{l3_account_category.title}",price(l3_account_category.balance(to_date: @to_date)) ]], cell_style: { padding: [2, 2], inline_format: true, size: 10}, column_widths: [330, 100]) do
              cells.borders = []
              column(1).align = :right
              row(-1).font_style = :bold
            end
          end 
        end
        stroke_horizontal_rule
        level_two_liability_account_categories.where.not(id: level_three_liability_account_categories.level_two_account_categories.liabilities.ids).each do |l2_account_category|
          if l2_account_category.show_sub_categories?
            table([["","#{l2_account_category.title}"]], cell_style: { padding: [2,2], inline_format: true, size: 10}, column_widths: [10, 320, 100]) do
              cells.borders = []
              column(2).align = :right
            end
            l2_account_category.level_one_account_categories.each do |l1_account_category|
              table([["", "", "#{l1_account_category.title}", price(l1_account_category.balance(to_date: @to_date))]], cell_style: { padding: [2,2], inline_format: true, size: 10}, column_widths: [10, 10, 310, 100]) do
                cells.borders = []
                column(3).align = :right
              end
            end
            stroke_horizontal_rule

            table([["", "Total #{l2_account_category.title}",price(l2_account_category.balance(to_date: @to_date)) ]], cell_style: { padding: [2, 2], inline_format: true, size: 10}, column_widths: [10, 320, 100]) do
              cells.borders = []
              column(2).align = :right
              row(-1).font_style = :bold
            end
          else 
            table([["", "#{l2_account_category.title}",price(l2_account_category.balance(to_date: @to_date)) ]], cell_style: { padding: [2, 2], inline_format: true, size: 10}, column_widths: [10, 320, 100]) do
              cells.borders = []
              column(2).align = :right
              row(-1).font_style = :bold
            end
          end
        end 
          level_one_liability_account_categories.where.not(id: level_two_liability_account_categories.level_one_account_categories.liabilities.ids).each do |l1_account_category|
            table([["", "", "#{l1_account_category.title}", price(l1_account_category.balance(to_date: @to_date))]], cell_style: { padding: [2,2], inline_format: true, size: 10}, column_widths: [10, 10, 310, 100]) do
              cells.borders = []
              column(3).align = :right
            end
          end

          stroke_horizontal_rule
          move_down 5

        table([["TOTAL LIABILITIES", price(all_level_one_liability_account_categories.balance(to_date: @to_date))]], cell_style: {padding: [2,2], inline_format: true, size: 10},
          column_widths: [330, 100]) do
            cells.borders = []
            column(0).font_style = :bold
            column(1).align = :right
            column(1).font_style = :bold
            row(-1).font_size = 14

          end
        
        move_down 10
        
        table([["EQUITY AND RESERVE"]], cell_style: {padding: [2,2], inline_format: true, size: 10}, column_widths: [230, 100]) do
          cells.borders = []
          column(0).font_style = :bold
        end
        level_three_equity_account_categories.order(code: :asc).each do |l3_account_category|
          if l3_account_category.show_sub_categories?
            table([["#{l3_account_category.title}"]], cell_style: {padding: [2,2], inline_format: true, size: 10}, column_widths: [230, 100]) do
              cells.borders = []
            end

            l3_account_category.level_two_account_categories.each do |l2_account_category|
              table([["","#{l2_account_category.title}"]], cell_style: { padding: [2,2], inline_format: true, size: 10}, column_widths: [10, 320, 100]) do
                cells.borders = []
                column(2).align = :right
              end

              l2_account_category.level_one_account_categories.each do |l1_account_category|
                table([["", "", "#{l1_account_category.title}", price(l1_account_category.balance(to_date: @to_date))]], cell_style: { padding: [2,2], inline_format: true, size: 10}, column_widths: [10, 10, 310, 100]) do
                  cells.borders = []
                  column(3).align = :right
                end
              end
              stroke_horizontal_rule

              table([["", "Total #{l2_account_category.title}",price(l2_account_category.balance(to_date: @to_date)) ]], cell_style: { padding: [2, 2], inline_format: true, size: 10}, column_widths: [10, 320, 100]) do
                cells.borders = []
                column(2).align = :right
                row(-1).font_style = :bold
              end
            end

            stroke_horizontal_rule
            table([["Total #{l3_account_category.title}",price(l3_account_category.balance(to_date: @to_date)) ]], cell_style: { padding: [2, 2], inline_format: true, size: 10}, column_widths: [330, 100]) do
              cells.borders = []
              column(1).align = :right
              row(-1).font_style = :bold
            end
          else 
            table([["#{l3_account_category.title}",price(l3_account_category.balance(to_date: @to_date)) ]], cell_style: { padding: [2, 2], inline_format: true, size: 10}, column_widths: [330, 100]) do
              cells.borders = []
              column(1).align = :right
              row(-1).font_style = :bold
            end
          end 
        end

        stroke_horizontal_rule
        level_two_equity_account_categories.where.not(id: level_three_equity_account_categories.level_two_account_categories.equities.ids).each do |l2_account_category|
          if l2_account_category.show_sub_categories?
            table([["","#{l2_account_category.title}"]], cell_style: { padding: [2,2], inline_format: true, size: 10}, column_widths: [10, 320, 100]) do
              cells.borders = []
              column(2).align = :right
            end
            l2_account_category.level_one_account_categories.each do |l1_account_category|
              table([["", "", "#{l1_account_category.title}", price(l1_account_category.balance(to_date: @to_date))]], cell_style: { padding: [2,2], inline_format: true, size: 10}, column_widths: [10, 10, 310, 100]) do
                cells.borders = []
                column(3).align = :right
              end
            end
            stroke_horizontal_rule

            table([["", "Total #{l2_account_category.title}",price(l2_account_category.balance(to_date: @to_date)) ]], cell_style: { padding: [2, 2], inline_format: true, size: 10}, column_widths: [10, 320, 100]) do
              cells.borders = []
              column(2).align = :right
              row(-1).font_style = :bold
            end
          else 
            table([["", "#{l2_account_category.title}",price(l2_account_category.balance(to_date: @to_date)) ]], cell_style: { padding: [2, 2], inline_format: true, size: 10}, column_widths: [10, 320, 100]) do
              cells.borders = []
              column(2).align = :right
              row(-1).font_style = :bold
            end 
          end
        end 
        level_one_equity_account_categories.where.not(id: level_two_equity_account_categories.level_one_account_categories.equities.ids).each do |l1_account_category|
          table([["", "", "#{l1_account_category.title}", price(l1_account_category.balance(to_date: @to_date))]], cell_style: { padding: [2,2], inline_format: true, size: 10}, column_widths: [10, 10, 310, 100]) do
            cells.borders = []
            column(3).align = :right
          end
        end

        stroke_horizontal_rule
        move_down 5
        table([["Undivided Net Surplus", price(net_surplus)]], cell_style: {padding: [2,2], inline_format: true, size: 10},
          column_widths: [330, 100]) do
            cells.borders = []
            column(0).font_style = :bold
            column(1).align = :right
            column(1).font_style = :bold
            row(-1).font_size = 14

          end
          stroke_horizontal_rule
          move_down 5

        table([["TOTAL EQUITY", price(all_level_one_equity_account_categories.balance(to_date: @to_date) + net_surplus)]], cell_style: {padding: [2,2], inline_format: true, size: 10},
          column_widths: [330, 100]) do
            cells.borders = []
            column(0).font_style = :bold
            column(1).align = :right
            column(1).font_style = :bold
            row(-1).font_size = 14

          end
        move_down 10
        stroke_horizontal_rule
        move_down 5
        table([["TOTAL LIABILITIES, EQUITY AND RESERVE", price(net_surplus + all_level_one_liability_account_categories.balance(to_date: @to_date) + all_level_one_equity_account_categories.balance(to_date: @to_date))]], cell_style: {padding: [2,2], inline_format: true, size: 10},
          column_widths: [330, 100]) do
            cells.borders = []
            column(0).font_style = :bold
            column(1).align = :right
            column(1).font_style = :bold
            row(-1).font_size = 14

          end
      end
      
      def net_surplus
        office.level_one_account_categories.revenues.balance(from_date: @from_date, to_date: @to_date) - office.level_one_account_categories.expenses.balance(from_date: @from_date, to_date: @to_date)
      end
    end
  end
end
