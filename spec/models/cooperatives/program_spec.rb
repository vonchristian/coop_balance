require 'rails_helper'

module Cooperatives
  describe Program, type: :model do
  	context 'associations' do
      it { is_expected.to belong_to :cooperative }
      it { is_expected.to have_many :program_subscriptions }
  		it { is_expected.to have_many :member_subscribers }
      it { is_expected.to have_many :employee_subscribers }
      it { is_expected.to have_many :organization_subscribers }
  	end

  	context 'validations' do
  		it { is_expected.to validate_presence_of :name }
      it { is_expected.to validate_presence_of :amount }
      it { is_expected.to validate_numericality_of :amount }
  		it { is_expected.to validate_uniqueness_of(:name).scoped_to(:cooperative_id) }
      it { is_expected.to validate_presence_of :payment_schedule_type }
  	end

  	it ".default_programs" do
  		default_program     = create(:program, default_program: true)
  		not_default_program = create(:program, default_program: false)

  		expect(described_class.default_programs).to include(default_program)
  		expect(described_class.default_programs).to_not include(not_default_program)
    end

    it do
      should define_enum_for(:payment_schedule_type).
      with_values([:one_time_payment, :annually, :monthly, :quarterly])
    end

    it "#payment_status_finder" do
        one_time_payment = create(:program, payment_schedule_type: 'one_time_payment')
        annually         = create(:program, payment_schedule_type: 'annually')
        quarterly        = create(:program, payment_schedule_type: 'quarterly')
        monthly          = create(:program, payment_schedule_type: 'monthly')

        expect(one_time_payment.payment_status_finder).to eq Programs::PaymentStatusFinders::OneTimePayment
        expect(annually.payment_status_finder).to         eq Programs::PaymentStatusFinders::Annually
        expect(quarterly.payment_status_finder).to        eq Programs::PaymentStatusFinders::Quarterly
        expect(monthly.payment_status_finder).to          eq Programs::PaymentStatusFinders::Monthly
    end

    it "#date_setter" do
      one_time_payment = create(:program, payment_schedule_type: 'one_time_payment')
      annually         = create(:program, payment_schedule_type: 'annually')
      quarterly        = create(:program, payment_schedule_type: 'quarterly')
      monthly          = create(:program, payment_schedule_type: 'monthly')

      expect(one_time_payment.date_setter).to eq Programs::DateSetters::OneTimePayment
      expect(annually.date_setter).to         eq Programs::DateSetters::Annually
      expect(quarterly.date_setter).to        eq Programs::DateSetters::Quarterly
      expect(monthly.date_setter).to          eq Programs::DateSetters::Monthly
  end

    it "#subscribed?(subscriber)" do
      member             = create(:member)
      program1           = create(:program)
      program2           = create(:program)
      subscribed_program = create(:program_subscription, subscriber: member, program: program1)

      expect(program1.subscribed?(member)).to eql true
      expect(program2.subscribed?(member)).to eql false
    end
  end
end
