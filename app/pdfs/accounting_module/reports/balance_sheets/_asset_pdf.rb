table([["ASSETS"]], cell_style: {padding: [2,2], inline_format: true, size: 10}, column_widths: [230, 100]) do
  cells.borders = []
  column(0).font_style = :bold
end

office.level_three_account_categories.assets.order(code: :asc).each do |l3_account_category|
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
      stroke_horizontal_rule

      table([["", "Total #{l2_account_category.title}",price(l2_account_category.balance(to_date: @to_date)) ]], cell_style: { padding: [2, 2], inline_format: true, size: 10}, column_widths: [10, 320, 100]) do
        cells.borders = []
        column(2).align = :right
        row(-1).font_style = :bold
      end
    end

    stroke_horizontal_rule
    table([["Total #{l3_account_category.title}",price(l2_account_category.balance(to_date: @to_date)) ]], cell_style: { padding: [2, 2], inline_format: true, size: 10}, column_widths: [330, 100]) do
      cells.borders = []
      column(1).align = :right
      row(-1).font_style = :bold
    end

  end
end

stroke_horizontal_rule
office.level_two_account_categories.assets.where.not(id: office.level_three_account_categories.assets.level_two_account_categories.assets.ids).each do |l2_account_category|
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
office.level_one_account_categories.assets.where.not(id: office.level_two_account_categories.assets.level_one_account_categories.assets.ids).each do |l1_account_category|
  table([["", "", "#{l1_account_category.title}", price(l1_account_category.balance(to_date: @to_date))]], cell_style: { padding: [2,2], inline_format: true, size: 10}, column_widths: [10, 10, 310, 100]) do
    cells.borders = []
    column(3).align = :right
  end
end

stroke_horizontal_rule
move_down 5

table([["TOTAL ASSETS", price(office.level_one_account_categories.assets.balance(to_date: @to_date))]], cell_style: {padding: [2,2], inline_format: true, size: 10},
  column_widths: [330, 100]) do
    cells.borders = []
    column(0).font_style = :bold
    column(1).align = :right
    column(1).font_style = :bold
    row(-1).font_size = 14

  end
move_down 10
