# require 'spec_helper'
#
# describe 'amortization schedule pdf' do
#     before do
#         @book = FactoryBot.build_stubbed(:loan).decorate
#         view_context = ActionController::Base.new.view_context
#          = LoansModule::LoanAmortizationSchedulePdf.new(
#            loan: @loan,
#            view_context: view_context,
#            voucher: @voucher,
#            term: @loan.term,
#            view_context)
#         rendered_pdf = pdf.render
#         @text_analysis = PDF::Inspector::Text.analyze(rendered_pdf)
#     end
#
#     specify { @text_analysis.strings.should include(@book.title) }
#
# end
