class MetricsPdf < Prawn::Document
  def initialize(members, revenues, expenses, from_date, to_date, view_context)
    super(margin: 40, page_size: 'A4', page_layout: :portrait)
    @members      = members
    @revenues     = revenues
    @expenses     = expenses
    @from_date    = from_date
    @to_date      = to_date
    @view_context = view_context
    heading
    served_members
    revenues_data
    expenses_data
    profits_data
  end

  private

  def price(number)
    @view_context.number_to_currency(number, unit: 'P ')
  end

  def heading
    bounding_box [300, 760], width: 50 do
      image Rails.root.join('app/assets/images/kccmc_logo.jpg').to_s, width: 40, height: 40
    end
    bounding_box [350, 760], width: 150 do
      text 'KCCMC', style: :bold, size: 22
      text 'Poblacion, Tinoc, Ifugao', size: 10
    end
    bounding_box [0, 760], width: 400 do
      text 'Metrics Report', style: :bold, size: 14
      move_down 5
      text "#{@from_date.strftime('%B %e, %Y')} - #{@to_date.strftime('%B %e, %Y')} ", size: 10
      move_down 5
    end
    move_down 10
    stroke do
      stroke_color 'CCCCCC'
      line_width 0.2
      stroke_horizontal_rule
      move_down 15
    end
  end

  def served_members
    text 'SERVED MEMBERS', size: 10
    move_down 4
    text @members.count.to_s, size: 24
  end

  def revenues_data
    move_down 10
    stroke do
      stroke_color 'CCCCCC'
      line_width 0.2
      stroke_horizontal_rule
      move_down 20
    end
    text 'REVENUES'
    text price(@revenues.balance(from_date: @from_date, to_date: @to_date)).to_s, size: 24
  end

  def expenses_data
    move_down 10
    stroke do
      stroke_color 'CCCCCC'
      line_width 0.2
      stroke_horizontal_rule
      move_down 20
    end
    text 'EXPENSES'
    text price(@expenses.balance(from_date: @from_date, to_date: @to_date)).to_s, size: 24
  end

  def profits_data
    move_down 10
    stroke do
      stroke_color 'CCCCCC'
      line_width 0.2
      stroke_horizontal_rule
      move_down 20
    end
    text 'PROFIT', color: '008751', style: :bold
    text price(@revenues.balance(from_date: @from_date, to_date: @to_date) - @expenses.balance(from_date: @from_date, to_date: @to_date)).to_s, size: 24
  end
end
