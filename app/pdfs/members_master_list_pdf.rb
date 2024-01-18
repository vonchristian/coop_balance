class MembersMasterListPdf < Prawn::Document
  attr_reader :view_context, :members, :organization, :membership_type, :cooperative

  def initialize(args = {})
    super(margin: [60, 30, 30, 30], page_size: [612, 936], page_layout: :landscape)
    @view_context = args[:view_context]
    @members      = args[:members]
    @cooperative  = args[:cooperative]
    @organization = Organization.find(args[:organization_id]) if args[:organization_id].present?
    @membership_type = args[:membership_type].titleize if args[:membership_type].present?

    heading
    members_table_body
    font Rails.root.join('app/assets/fonts/open_sans_regular.ttf')
  end

  private

  def subtitle
    if organization.present?
      organization.name.to_s
    else
      ''
    end
  end

  def title
    if membership_type.present?
      "List of #{membership_type.pluralize}"
    else
      'List of Regular and Associate Members'
    end
  end

  def beneficiaries(member)
    sc_beneficiaries = member.share_capitals.pluck(:beneficiaries).map { |b| ["#{b} (SC)"] }
    maf_beneficiaries = member.share_capitals.pluck(:maf_beneficiaries).map { |b| ["#{b} (MAF)"] }
    td_beneficiaries = member.time_deposits.not_withdrawn.pluck(:beneficiaries).map { |b| ["#{b} (TD)"] }
    sd_beneficiaries = member.savings.pluck(:beneficiaries).map { |b| ["#{b} (SD)"] }
    (sc_beneficiaries + maf_beneficiaries + td_beneficiaries + sd_beneficiaries).uniq.compact.join(', ')
  end

  def short_term_loan(member)
    if member.current_membership.regular_member?
      LoansModule::LoanProduct.where('name like ?', '%Short-Term Loan(Member)%').first
    else
      LoansModule::LoanProduct.where('name like ?', '%Short-Term Loan(Non-Member)%').first
    end
  end

  def regular_loan
    LoansModule::LoanProduct.where('name like ?', '%Regular Loan%').first
  end

  def emergency_loan
    LoansModule::LoanProduct.where('name like ?', '%Emergency Loan%').first
  end

  def appliance_loan
    LoansModule::LoanProduct.where('name like ?', '%Appliance Loan%').first
  end

  def productive_loan
    LoansModule::LoanProduct.where('name like ?', '%Productive Loan%').first
  end

  def price(number)
    view_context.number_to_currency(number, unit: 'P ')
  end

  def logo
    { image: Rails.root.join("app/assets/images/#{cooperative.abbreviated_name.downcase}_logo.jpg").to_s, image_width: 50, image_height: 50 }
  end

  def subtable_right
    sub_data ||=  [[{ content: cooperative.abbreviated_name.to_s, size: 22 }]] +
                  [[{ content: cooperative.name.to_s, size: 10 }]]
    make_table(sub_data, cell_style: { padding: [0, 5, 1, 2] }) do
      columns(0).width = 140
      cells.borders = []
    end
  end

  def subtable_left
    sub_data ||= [[{ content: title, size: 14, colspan: 2 }]] +
                 [[{ content: subtitle, size: 10, colspan: 2 }]]
    make_table(sub_data, cell_style: { padding: [0, 5, 1, 2] }) do
      columns(0).width = 80
      columns(1).width = 230
      cells.borders = []
    end
  end

  # 275, 50, 210
  def heading
    bounding_box [bounds.left, bounds.top], width: 936 do
      table([[subtable_left, logo, subtable_right]],
            cell_style: { inline_format: true, font: 'Helvetica', padding: [0, 5, 0, 0] },
            column_widths: [686, 50, 140]) do
        cells.borders = []
      end
    end
    stroke do
      move_down 3
      stroke_color '24292E'
      line_width 1
      stroke_horizontal_rule
      move_down 1
    end
    move_down 10
  end

  def members_table_header
    table([['LAST NAME', 'FIRST NAME', 'MIDDLE NAME', 'SEX', 'BIRTH DATE',
            'AGE', 'CIVIL STATUS', 'ADDRESS', 'MOBILE NUMBER', 'BENEFICIARIES',
            'SHORT-TERM LOAN BALANCE', 'REGULAR LOAN BALANCE', 'EMERGENCY LOAN BALANCE',
            'APPLIANCE LOAN BALANCE', 'PRODUCTIVE LOAN BALANCE', 'SAVINGS DEPOSIT BALANCE',
            'TIME DEPOSIT BALANCE', 'SHARE CAPITAL BALANCE']],
          cell_style: { inline_format: true, size: 7, font: 'Helvetica', padding: [4, 3, 4, 3] },
          column_widths: [40, 40, 40, 20, 40, 20, 40, 80, 56, 70, 55, 55, 55, 55, 55, 55, 50, 50]) do # total width = 876
      row(0).font_style = :bold
      row(0).background_color = 'DDDDDD'
      column(10).align = :right
      column(11).align = :right
      column(12).align = :right
      column(13).align = :right
      column(14).align = :right
      column(15).align = :right
      column(16).align = :right
      column(17).align = :right
    end
  end

  def members_table_body
    members_table_header
    if members.none?
      move_down 10
      text 'No members data.', align: :center
    else
      table(members_data,
            cell_style: { inline_format: true, size: 7, font: 'Helvetica', padding: [1, 3, 2, 2] },
            column_widths: [40, 40, 40, 20, 40, 20, 40, 80, 56, 70, 55, 55, 55, 55, 55, 55, 50, 50]) do
        column(10).align = :right
        column(11).align = :right
        column(12).align = :right
        column(13).align = :right
        column(14).align = :right
        column(15).align = :right
        column(16).align = :right
        column(17).align = :right
      end
    end
  end

  def members_data
    members.order(:last_name).map { |m|
      [
        m.last_name, m.first_name, m.middle_name,
        m.sex.present? ? m.sex.first.titleize : '-',
        m.date_of_birth.try(:strftime, '%D'),
        m.date_of_birth.present? ? m.age : '',
        m.civil_status.try(:titleize),
        m.addresses.present? ? m.current_address_complete_address : '-',
        m.addresses.present? ? m.current_contact_number : '-',
        beneficiaries(m),
        loan_balance(member: m, loan_product: short_term_loan(m)),
        loan_balance(member: m, loan_product: regular_loan),
        loan_balance(member: m, loan_product: emergency_loan),
        loan_balance(member: m, loan_product: appliance_loan),
        loan_balance(member: m, loan_product: productive_loan),
        savings_account_balance(member: m),
        time_deposits_balance(member: m),
        share_capital_balance(member: m)
      ]
    }
  end

  def loan_balance(args = {})
    member = args.fetch(:member)
    loan_product = args.fetch(:loan_product)
    balance = member.loans_for(loan_product: loan_product).sum { |l| l.principal_balance(to_date: Time.zone.now) }
    if balance.to_i.zero?
      '-'
    else
      price(balance)
    end
  end

  def savings_account_balance(args = {})
    member = args.fetch(:member)
    balance = member.savings.sum { |s| s.balance(to_date: Time.zone.now) }
    if balance.to_i.zero?
      '-'
    else
      price(balance)
    end
  end

  def time_deposits_balance(args = {})
    member = args.fetch(:member)
    balance = member.time_deposits.sum { |s| s.balance(to_date: Time.zone.now) }
    if balance.to_i.zero?
      '-'
    else
      price(balance)
    end
  end

  def share_capital_balance(args = {})
    member = args.fetch(:member)
    balance = member.share_capitals.sum { |s| s.balance(to_date: Time.zone.now) }
    if balance.to_i.zero?
      '-'
    else
      price(balance)
    end
  end
end