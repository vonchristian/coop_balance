require 'barby'
require 'barby/barcode/code_128'
require 'barby/outputter/prawn_outputter'
class VoucherPdf < Prawn::Document
  attr_reader :voucher, :cooperative, :view_context, :title
  def initialize(args={})
    super(margin: 40, page_size: "A4", page_layout: :portrait)
    @title = args[:title] || "Cash Disbursement Voucher"
    @voucher = args[:voucher]
    @cooperative = @voucher.cooperative
    @view_context = args[:view_context]
    heading
    payee_details
    voucher_details
    signatory_details
    font Rails.root.join("app/assets/fonts/open_sans_regular.ttf")
    
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
      text "#{title.upcase}", style: :bold, size: 12
      text "CDV No: #{voucher.reference_number}", style: :bold, size: 10
    end
    move_down 30
    stroke do
      stroke_color '24292E'
      line_width 1
      stroke_horizontal_rule
      move_down 5
    end
  end
  def payee_details
    text "VOUCHER DETAILS", style: :bold, size: 10
    move_down 5
    table([["", "Payee:", "<b>#{voucher.payee.try(:name).try(:upcase)}</b>", "Date:", "#{voucher.date.strftime("%B %e, %Y")}"]], cell_style: { inline_format: true, size: 10, font: "Helvetica", :padding => [2, 4, 2, 4]}, column_widths: [20, 100, 180, 115, 100]) do
      cells.borders = []
    end

    table([["", "Office:", "#{voucher.payee.try(:current_organization).try(:name)}", "", ""]], cell_style: { inline_format: true, size: 10, font: "Helvetica", :padding => [2, 4, 2, 4]}, column_widths: [20, 100, 180, 115, 100]) do
      cells.borders = []
    end

    table([["", "Address:", "#{voucher.payee.current_address.try(:complete_address)}", "", ""]], cell_style: { inline_format: true, size: 10, font: "Helvetica", :padding => [2, 4, 2, 4]}, column_widths: [20, 100, 200, 95, 100]) do
      cells.borders = []
    end

    table([["", "Contact #:", "#{voucher.payee.current_contact.try(:number)}", "", ""]], cell_style: { inline_format: true, size: 10, font: "Helvetica", :padding => [2, 4, 2, 4]}, column_widths: [20, 100, 200, 95, 100]) do
      cells.borders = []
    end

    table([["", "Description:", "#{voucher.description}", "", ""]], cell_style: { inline_format: true, size: 10, font: "Helvetica", :padding => [2, 4, 2, 4]}, column_widths: [20, 100, 200, 95, 100]) do
      cells.borders = []
    end

    stroke do
      move_down 5
      stroke_color 'CCCCCC'
      line_width 0.2
      stroke_horizontal_rule
      move_down 5
    end
  end
  def approver
    User.general_manager.last
  end



  def debit_amount_for(amount)
    if amount.debit?
      amount.amount
    end
  end
  def credit_amount_for(amount)
    if amount.credit?
      amount.amount
    end
  end

  def voucher_details
    move_down 10
    table([["DEBIT", "ACCOUNT", "CREDIT"]], cell_style: { inline_format: true, size: 10, font: "Helvetica"},  column_widths: [100, 300, 100]) do
      row(0).background_color = "DDDDDD"
      row(0).font_style = :bold
    end
    if voucher.disbursed?
      voucher.accounting_entry.debit_amounts.order(type: :desc).each do |amount|
        table([["#{price(debit_amount_for(amount))}", "#{amount.account.try(:name)}",  "#{price(credit_amount_for(amount))}"]], cell_style: { inline_format: true, size: 10, font: "Helvetica"}, column_widths: [100, 300, 100]) do
          # cells.borders = []
          column(0).align = :right
          column(2).align = :right
        end
      end
      voucher.accounting_entry.credit_amounts.order(type: :desc).each do |amount|
        table([["#{price(debit_amount_for(amount))}", "#{amount.account.try(:name)}",  "#{price(credit_amount_for(amount))}"]], cell_style: { inline_format: true, size: 10, font: "Helvetica"}, column_widths: [100, 300, 100]) do
          # cells.borders = []
          column(0).align = :right
          column(2).align = :right
        end
      end
    else
      voucher.voucher_amounts.debit.order(amount_type: :desc).each do |amount|
        table([["#{price(debit_amount_for(amount))}", "#{amount.account.try(:name)}", "#{price(credit_amount_for(amount))}"]], cell_style: { inline_format: true, size: 10, font: "Helvetica"}, column_widths: [100, 300, 100]) do
          # cells.borders = []
          column(0).align = :right
          column(2).align = :right
        end
      end
      voucher.voucher_amounts.credit.order(amount_type: :desc).each do |amount|
        table([["#{price(debit_amount_for(amount))}", "#{amount.account.try(:name)}", "#{price(credit_amount_for(amount))}"]], cell_style: { inline_format: true, size: 10, font: "Helvetica"}, column_widths: [100, 300, 100]) do
          # cells.borders = []
          column(0).align = :right
          column(2).align = :right
        end
      end
    end
    if voucher.disbursed?
      table([["#{price(voucher.accounting_entry.debit_amounts.sum(&:amount))}", "", "#{price(voucher.accounting_entry.credit_amounts.sum(&:amount))}"]], cell_style: { inline_format: true, size: 10, font: "Helvetica"},  column_widths: [100, 300, 100]) do
        # cells.borders = []
        row(0).font_style = :bold
        column(0).align = :right
        column(2).align = :right
      end
    else
      table([["#{price(voucher.voucher_amounts.debit.sum(&:amount))}", "", "#{price(voucher.voucher_amounts.debit.sum(&:amount))}"]], cell_style: { inline_format: true, size: 10, font: "Helvetica"},  column_widths: [100, 300, 100]) do
        # cells.borders = []
        row(0).font_style = :bold
        column(0).align = :right
        column(2).align = :right
      end
    end
  end
  def signatory_details
    move_down 50
    table([["PREPARED BY", "APPROVED BY", "DISBURSED BY", "RECEIVED BY"]], 
      cell_style: { inline_format: true, size: 10, font: "Helvetica", :padding => [2, 4, 2, 4]}, 
      column_widths: [120, 120, 120, 140]) do
        cells.borders = []
    end
    move_down 30
    table(signatory, cell_style: { inline_format: true, size: 9, font: "Helvetica", :padding => [2, 4, 2, 4]}, column_widths: [120, 120, 120, 140]) do
      cells.borders = []
      row(0).font_style = :bold
    end
  end

  def signatory
    [["#{voucher.preparer.first_middle_and_last_name.to_s.try(:upcase)}",
      "#{approver.first_middle_and_last_name.to_s.upcase}",
      "#{voucher.disbursing_officer.try(:first_middle_and_last_name).try(:upcase)}",
      "#{voucher.payee.first_middle_and_last_name.try(:upcase)}"]] +
    [["#{voucher.preparer_current_occupation.try(:titleize)}",
      "#{approver.current_occupation.to_s.titleize}",
      "#{voucher.disbursing_officer.try(:designation)}",
      "Payee"]]
  end
end
