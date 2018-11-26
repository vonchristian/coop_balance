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
      text "CDV No: #{voucher.number}", style: :bold, size: 10
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
      table([["", "Payee:", "<b>#{voucher.payee.try(:name).try(:upcase)}</b>"]], cell_style: { inline_format: true, size: 10, font: "Helvetica"}, column_widths: [20, 100, 300]) do
          cells.borders = []
        end
      table([["", "Description:", "#{voucher.description}"]], cell_style: { inline_format: true, size: 10, font: "Helvetica"}, column_widths: [20, 100, 300]) do
        cells.borders = []
      end
      table([["", "Date:", "#{voucher.date.strftime("%B %e, %Y")}"]], cell_style: { inline_format: true, size: 10, font: "Helvetica"}, column_widths: [20, 100, 300]) do
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
      voucher.accounting_entry.amounts.each do |amount|
      table([["#{price(debit_amount_for(amount))}", "#{amount.account.try(:name)}",  "#{price(credit_amount_for(amount))}"]], cell_style: { inline_format: true, size: 10, font: "Helvetica"}, column_widths: [100, 300, 100]) do
        # cells.borders = []
        column(0).align = :right
        column(2).align = :right
      end
    end
    else
      voucher.voucher_amounts.each do |amount|
        table([["#{price(debit_amount_for(amount))}", "#{amount.account.try(:name)}",   "#{price(credit_amount_for(amount))}"]], cell_style: { inline_format: true, size: 10, font: "Helvetica"}, column_widths: [100, 300, 100]) do
          # cells.borders = []
          column(0).align = :right
          column(2).align = :right
        end
      end
    end
    if voucher.disbursed?
      table([["#{price(voucher.accounting_entry.debit_amounts.sum(:amount))}", "", "#{price(voucher.accounting_entry.credit_amounts.sum(:amount))}"]], cell_style: { inline_format: true, size: 10, font: "Helvetica"},  column_widths: [100, 300, 100]) do
      # cells.borders = []
      row(0).font_style = :bold
      column(0).align = :right
      column(2).align = :right
     end
    else
    table([["#{price(voucher.voucher_amounts.debit.sum(&:amount))}", "", "#{price(voucher.voucher_amounts.debit.sum(&:amount))}"]], cell_style: { inline_format: true, size: 10, font: "Helvetica"},  column_widths: [100, 300, 100]) do
      # cells.borders = []
      row(0).font_style = :bold
      column(2).align = :right
      column(3).align = :right
    end
  end
  end
  def signatory_details
    move_down 50
      table(signatory, cell_style: { inline_format: true, size: 9, font: "Helvetica"}, column_widths: [120, 120, 120, 120]) do
        cells.borders = []
        row(2).font_style = :bold
     end
   end
   def signatory
    [["PREPARED BY", "DISBURSED BY", "APPROVED BY", "RECEIVED BY"]] +
    [["", ""]] +
    [["#{voucher.preparer_full_name.to_s.try(:upcase)}", "#{voucher.disburser_full_name.to_s.try(:upcase)}", "#{approver.name.to_s.upcase}", "#{voucher.payee_name.try(:upcase)}"]] +
    [["#{voucher.preparer_current_occupation.try(:titleize)}", "#{voucher.disburser_current_occupation.try(:titleize)}", "#{approver.current_occupation.to_s.titleize}", "Payee"]]
  end
end
