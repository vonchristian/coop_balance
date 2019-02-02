remove accrued -> move to add_on
loan application belongs_to amortization_type
loan_application belongs_to interest_config
member index
  just for searching
  separate to membership portfolio (metrics)

color code loans
red past due
restructured yellow
blue current
litigation gray
add Restructured account to loan product creation


pdf format loan application form
create municipalities
create barangays
create provinces


Backlog

Appraisal Sheet for collateralled Real Properties





share capital show page
 if less than minimum show amount balance
add cooperative service to loan products
add cooperative service to share capital products
add cooperative service to saving products
add cooperative service to time deposit products

balance averaging for share capital product
balance averaging for saving product

interest_earned_posting_status_finder for saving product

test loan payment processors

test loan product creation
  add iterest prededuction
  add interest calculation type



<div class="card">
  <div class="card-body">
    <div class="row">
      <div class="col-md-1 col-sm-1">
        <% if loan_application.borrower.avatar.attachment.present? %>
          <%=image_tag(loan_application.borrower.avatar, height: 45, width: 45, class: "img-circle") %>
        <% end %>
      </div>
      <div class="col-md-3 col-sm-3">
        <% if loan_application.voucher.present? %>
          <%= link_to loans_module_loan_application_path(loan_application) do %>
          <b><%=  loan_application.borrower_name.try(:upcase) %></b><br>
          <% end %>
        <% end %>
        <small class="text-muted"><i class="fa fa-tag"></i> <%= loan_application.loan_product_name %><br>
         <i class="fa fa-calendar"></i> <%= loan_application.voucher.try(:date).try(:strftime, "%B %e, %Y") %>
        </small>
      </div>
      <div class="col-md-8">
        <div class="row">
          <div class="col-md-6 col-sm-7">
            <% if loan_application.voucher.present? %>
              <%= link_to loans_module_loan_application_path(loan_application) do %>
              <b><%=  loan_application.borrower_name.try(:upcase) %></b><br>
              <% end %>
            <% end %>
            <small class="text-muted"><i class="fa fa-tag"></i> <%= loan_application.loan_product_name %><br>
             <i class="fa fa-calendar"></i> <%= loan_application.voucher.try(:date).try(:strftime, "%B %e, %Y") %>
            </small>
          </div>
          <div class="col-md-6 col-sm-5">
            <p class="number total"><%= number_to_currency loan_application.loan_amount %></p>
            <small class="text-muted">LOAN AMOUNT</small><br>
          </div>
        </div>
      </div>
      <div class="col-md-1 col-sm-2">
        <% if loan_application.voucher.present? %>
          <p class="text-muted"><%= "##{loan_application.voucher.reference_number}" %></p>
        <% end %>
      </div>
      <div class="col-md-2 col-sm-9">
        <% if loan_application.voucher.present? %>
          <%= link_to 'View Voucher', loans_module_loan_application_voucher_path(loan_application_id: loan_application.id, id: loan_application.voucher_id), class: "btn btn-primary btn-sm float-right" %>
        <% end %>
      </div>
      <div class="col-md-2 col-sm-3">
        <center>
          <% if !loan_application.disbursed? %>
            <%= link_to loans_module_loan_application_path(loan_application), method: :delete do %>
              <span title="Cancel Loan Application" data-toggle="tooltip" class="fa fa-times text-danger"> Cancel</span>
            <% end %>
          <% end %>
          </div>
          <div class="col-md-3 col-sm-2">
            <% if loan_application.voucher.present? %>
              <%= link_to 'View Voucher', loans_module_loan_application_voucher_path(loan_application_id: loan_application.id, id: loan_application.voucher_id), class: "btn btn-primary btn-sm float-right" %>
            <% end %>
          </div>
          <div class="col-md-3 col-sm-2">
            <center>
              <% if !loan_application.disbursed? %>
                <%= link_to loans_module_loan_application_path(loan_application), method: :delete do %>
                  <span title="Cancel Loan Application" data-toggle="tooltip" class="fa fa-times text-danger"> Cancel</span>
                <% end %>
              <% else %>
                <% if loan_application.cancelled == true %>
                  <span class="text-danger"> Cancelled</span>
                <% else %>
                  <span class="fa fa-check text-success"> Approved</span>
                <% end %>
              <% end %>
            </center>
          </div>
        </div>
        <small class="text-muted"><%= loan_application.try(:purpose) %></small>
      </div>
    </div>
  </div>
</div>




1500 principal
  500 interest
  penalty 100
loans receivable 2000
penalty                  100
interest_revenue         500

cash                    2100
unearned_interest_income 500

def second_year_principal_balance_schedule_finder
  ("LoansModule::ScheduleFinders::SecondYear::" + mode_of_payment.titleize.gsub(" ", "")).constantize
end




Creating a product people needed
Treating our customers with kindness and respect
Making small improvements and changes
Keeping costs in line and maintaining profitability
scan to pay

mobile wallet
account number
account_owner :polymorphic
liability_account

SCOPE ALL ENTRIES TO OFFICE

67709F
custom validator




sudo /home/deploy/.local/share/letsencrypt/bin/letsencrypt certonly --webroot --webroot-path /home/deploy/coopcatalyst/current/public --renew-by-default --email vc.halip@gmail.com --text --agree-tos -d coopcatalyst.co -d coopcatalyst.co


listen 443 ssl;

        ssl_certificate /etc/letsencrypt/live/example.com/fullchain.pem;
        ssl_certificate_key /etc/letsencrypt/live/example.com/privkey.pem;

        ssl_session_timeout 5m;
        ssl_protocols TLSv1 TLSv1.1 TLSv1.2;
        ssl_ciphers 'ECDHE-RSA-AES128-GCM-SHA256:ECDHE-ECDSA-AES128-GCM-SHA256:ECDHE-RSA-AES256-GCM-SHA384:ECDHE-ECDSA-AES256-GCM-SHA384:DHE-RSA-AES128-GCM-SHA256:DHE-DSS-AES128-GCM-SHA256:kEDH+AESGCM:ECDHE-RSA-AES128-SHA256:ECDHE-ECDSA-AES128-SHA256:ECDHE-RSA-AES128-SHA:ECDHE-ECDSA-AES128-SHA:ECDHE-RSA-AES256-SHA384:ECDHE-ECDSA-AES256-SHA384:ECDHE-RSA-AES256-SHA:ECDHE-ECDSA-AES256-SHA:DHE-RSA-AES128-SHA256:DHE-RSA-AES128-SHA:DHE-DSS-AES128-SHA256:DHE-RSA-AES256-SHA256:DHE-DSS-AES256-SHA:DHE-RSA-AES256-SHA:AES128-GCM-SHA256:AES256-GCM-SHA384:AES128-SHA256:AES256-SHA256:AES128-SHA:AES256-SHA:AES:CAMELLIA:DES-CBC3-SHA:!aNULL:!eNULL:!EXPORT:!DES:!RC4:!MD5:!PSK:!aECDH:!EDH-DSS-DES-CBC3-SHA:!EDH-RSA-DES-CBC3-SHA:!KRB5-DES-CBC3-SHA';
        ssl_prefer_server_ciphers on;
        ssl_session_cache shared:SSL:10m;
        ssl_dhparam /home/deploy/dhparams.pem;
.bg-indigo-dark
#5661b3
gray background
#f1f5f8
rename loan_creation_processing to loans::opening
sales report
date/customer/ref#/amount/total
a/r report
date/member/amount/items/total

purchases report
date / supplier/quantity/uom/items/unit cost/total/cost/selling price

stock card
name:
uom:
price:
date/ref#/voucher #/ purchases/sold/returned/spoilage/balance

Stock Inventory Report
as of :date

product name / uom/ unit_cost/in stock/ cost of inventory
disable destroy of voucher amounts if voucher is disbursed

set loan as loss
<div class="row">
  <div class="col-md-12">
    <div class="card">
      <div class="card-body">
   <h4>Expenses vs. Revenue</h4>
    <% month_dates = [] %>
    <% (Date.today.beginning_of_year..Date.today.end_of_month).each do |date| %>

      <% month_dates << date.end_of_month %>
    <% end %>
    <% revenues_accounts_data = [] %>
    <% month_dates.uniq.each do |month| %>
      <% revenues_accounts_data << { month.strftime("%B") => AccountingModule::Revenue.balance(to_date: month.end_of_month) } %>
    <% end %>
    <% expenses_accounts_data = [] %>
    <% month_dates.uniq.each do |month| %>
      <% expenses_accounts_data << { month.strftime("%B") => AccountingModule::Expense.balance(to_date: month.end_of_month) } %>
    <% end %>

    <%= line_chart [
      {name: "Revenues", data: (Hash[*revenues_accounts_data.collect{|h| h.to_a}.flatten].delete_if{|k,v| v.blank?}) },
      {name: "Expenses", data: (Hash[*expenses_accounts_data.collect{|h| h.to_a}.flatten].delete_if{|k,v| v.blank?}) }
    ], curve: false, thousands: "," %>
    <hr>
<h3 class="card-title"> Net Surplus </h3>
<% net_surplus_data = [] %>
<% month_dates.uniq.each do |month| %>
  <% net_surplus_data << { month.strftime("%B") => AccountingModule::Account.net_surplus(to_date: month.end_of_month) } %>
<% end %>
<%= line_chart (Hash[*net_surplus_data.collect{|h| h.to_a}.flatten].delete_if{|k,v| v.blank?}),messages: {empty: "No data"}, thousands: ",", curve: false %>

only debit active accounts
generate debit entries pdf report per account
generate credit entries report per account

Interest Posting done
   create voucher done
   post entry done



show savings and share capitals on top on info
fix notices template
edit share capital product

update last transaction date of members / organizations

check voucher generate number

clean up
  controllers
  views
  forms

move loan product to coop services module
Add qr code for payment

add policies

add membership_application model

refactor creation of voucher form

click the same button capybara
TODO
refactor LPF
time deposit certificate



TINOC MIGRATION
migrate voucher entry
add cooperative to
savings
loans
share capitals
time deposits


User roles
  accounting_officer
  collection_officer
  loan_officer
  management_officer
  sales_officer
  inventory_officer

<div class="row">
  <div class="col-md-3 border-right">
    <center>
      <p><b><%= @loan.tracking_number %></b></p>
      <small>TRACKING #</small>
    </center>
  </div>
  <div class="col-md-3 border-right">
    <center>
      <%= @loan.last_transaction_date.try(:strftime, ("%B %e, %Y")) %><br>
      <small>LAST PAYMENT DATE</small>
    </center>
  </div>
  <div class="col-md-3">
    <% if @loan.is_past_due? %>
      <center>
        <h3 class="card-title"><%= @loan.number_of_days_past_due %>
        </h3>
        <small> DAYS PAST DUE </small>
      </center>
    <% elsif @loan.current? %>
      <center>
        <h3 class="card-title"><%= @loan.remaining_term %>
        </h3>
        <small> REMAINING TERM (DAYS) </small>
      </center>
    <% end %>
  </div>
</div>
<hr>

<!DOCTYPE html>
<html>
  <head>
<title><%= content_for?(:html_title) ? yield(:html_title) : "CoopCatalyst" %></title>
    <%= csrf_meta_tags %>

    <%= stylesheet_link_tag    'application', media: 'all', 'data-turbolinks-track': 'reload' %>
    <%= javascript_include_tag 'application', 'data-turbolinks-track': 'reload' %>

  </head>
  <body class="hold-transition skin-black-light sidebar-mini">
    <div class="wrapper">
      <%=render "layouts/shared/header" %>
      <% if current_user.bookkeeper? || current_user.accountant? %>
        <%=render "accounting_module/sidebar" %>
      <% end %>
      <% if current_user.loan_officer? %>
        <%=render "loans_module/sidebar_for_loans_department" %>
      <% end %>
      <% if current_user.general_manager? %>
        <%=render "management_module/sidebar_for_management_department" %>
      <% end %>
      <% if current_user.teller? %>
        <%=render "teller_module/sidebar_for_teller_department" %>
      <% end %>
      <% if current_user.stock_custodian? %>
        <%=render "store_front_module/sidebar_for_stock_custodian" %>
      <% end %>
      <% if current_user.sales_clerk? %>
        <%=render "store_front_module/sidebar_for_sales_clerk" %>
      <% end %>
      <% if current_user.sales_manager? %>
        <%=render "store_front_module/sidebar_for_store" %>
      <% end %>
       <% if current_user.treasurer? %>
        <%=render "treasury_module/sidebar" %>
      <% end %>
      <% if current_user.accounting_clerk? %>
        <%=render "clerk_module/sidebar" %>
      <% end %>
       <% if current_user.collector? %>
        <%=render "collector_module/sidebar" %>
      <% end %>
      <div class="content-wrapper">
        <section class="content">
          <%=render "layouts/shared/flash_messages" %>
          <%= yield %>
        </section>
      </div>
        <%=render 'layouts/shared/footer', cached: true %>
    </div>

  </body>
</html>
credit rating per loan
credit rating per borrower
if loan is archived?
   disable all buttons
   show archived on loan show
   end
merging of savings account
check loan interest on loan
fix amortization schedule
edit entries


efficiency target

total loans receivable / total loan payments

low past due rate



background job for penalty computation



time deposit earned interests entry to:
  entry to savings
  entry to share capital



Records Problems

duplicated member records

savings balances with adjustments

loans with no tracking number

time deposit treated as savings






single cash on hand on LOAN PAYMENT

net surplus line chart

loan disbursements chart (laon balance)
loan maturity chart (loan balance)


CHECK
Loan amortization PDF

Add system tests


move loan product to coop_services_module

TODO
update savings (has_minimum_balance)


+++++++++++++++++++++++++++++++++++++++=
upstream tebtebba {
        server unix:///var/www/tebtebba/shared/tmp/socke$
}
server {
        listen 80;
        server_name 68.233.45.219; # change to match you$
        root /var/www/tebtebba/current/public; # I assum$
        location / {
                proxy_pass http://tebtebba; # match the $
                proxy_set_header Host $host;
                proxy_set_header X-Forwarded-For $proxy_$
        }

        location ~* ^/assets/ {
                # Per RFC2616 - 1 year maximum expiry
                expires 1y;
                add_header Cache-Control public;

                # Some browsers still send conditional-G$
                # Last-Modified header or an ETag header$
                # reached the expiry date sent in the Ex$
                add_header Last-Modified "";
                add_header ETag "";
                break;
        }
}


METRICS

1% SHARE CAPITAL INCREASE PER MONTH
1% SAVINGS INCREASE PER MONTH



STATUS OF PER BARANGAY
SAVINGS
SHARE CAPITALS


CROPITAL


ef balance(options={})
  first_entry_date = AccountingModule::Entry.order(entry_date: :desc).last.try(:entry_date) || Date.today
  from_date = options[:from_date]
  to_date = options[:to_date]
  commercial_document = options[:commercial_document]
  if commercial_document.present? && from_date.present? && to_date.present?
    balance_for(options).
    entered_on(options).
    sum(:amount)
  elsif commercial_document.blank? && from_date.present? && to_date.present?
    entered_on(options).
    sum(:amount)
  elsif commercial_document.present? && from_date.blank? && to_date.blank?
    balance_for(options).
    sum(:amount)
  elsif commercial_document.blank? && from_date.blank? && to_date.present?
    entered_on(from_date: first_entry_date, to_date: options[:to_date]).
    sum(:amount)
  else
    joins(:entry, :account).
    sum(:amount)
  end
end


<h4>BALANCES / YEAR </h4>
<% year_dates = [] %>
<% start_date = MembershipsModule::Saving.order(date_opened: :desc).last.date_opened %>
<% (start_date.to_date..Date.today).each do |date| %>

  <% year_dates << date.end_of_year%>
<% end %>
<% savings_balances_data = [] %>
<% year_dates.uniq.each do |year| %>
<% savings_balances_data << { year.end_of_year.strftime("%B %Y") => CoopServicesModule::SavingProduct.total_balances(to_date: year.end_of_year) } %>
<% end %>
<%= line_chart (Hash[*savings_balances_data.collect{|h| h.to_a}.flatten].delete_if{|k,v| v.blank?}),messages: {empty: "No data"} %>




Keep expenses down

<h4>Loans Receivables </h4>
<div class="row">
  <div class="col-md-4">
    <% loan_product_balances_data = [] %>
    <% LoansModule::LoanProduct.loans_receivable_current_accounts.each do |account| %>
    <% loan_product_balances_data << { account.name => account.balance } %>
    <% end %>
    <% LoansModule::LoanProduct.loans_receivable_current_accounts.each do |account| %>
      <div class="row">
        <div class="col-md-6">
          <%= account.name %>
        </div>
        <div class="col-md-6">
          <span class="pull-right"><%= number_to_currency account.balance %></span>
        </div>
      </div>
      <br />
    <% end %>
  </div>
  <div class="col-md-8">
    <%= bar_chart (Hash[*loan_product_balances_data.collect{|h| h.to_a}.flatten].delete_if{|k,v| v.blank?}),messages: {empty: "No data"}, prefix: "P ", width: "800px", height: "500px", legend: false, label: "Value" %>
  </div>
</div>



old loans


Merging of members
merging of share capitals



You must have something that drives you
You must operate with a “deathbed mentality” and not undervalue your time
You must be willing to experiment and fail continually
You can’t be a coward, which means you go against your intuition because you fear what others think (the scientific definition of courage means you deliberately confront risks to achieve a “noble goal”)
You need to be an intense and wise learner, which means you get the best information from the best resources and apply immediately what you learn

Per barangay of loan
add maturity date
per loan product per barangay
per organization

loan unearned interest posting


check loan payment interest and penalty

make loan term and time deposit term to be polymorphic


single entry for interest on deposits
process unearned interest income that is prededucted


rename memberships module to cooperators module

move time deposit to savings accounts
setup guard rspec

filter to current office


Decrement sales return if barcode is present?


REFACTOR
try facade pattern for line item transactions

payment of store credits
<a href="#" class="text-muted"><i class="fa fa-gear"></i></a>

segregate store_front_module_to rails_engine

Bacnong
Boton
Daw-es
Salupey


transform the cooperative industry
eliminate much of the manual, time consuming effort currently required to keep disparate ledgers.
Financial agreements are recorded and automatically managed without error, where anybody can transact seamlessly for any contractual purpose without friction.

We believe markets will move towards models where parties collaborate to maintain accurate, shared records of these agreements. Duplications, reconcilations will be thigs of the past.
We aspire to define a shared ledger fabric for cooperatives that relies on proven technologies.


# Cooperative Management Platform

This project integrates the services of a cooperative in a single platform so that managing is easier and more transaparent.

These services are included:

* Loans Module
* Accounting Module
* Cooperative Services Module
* Members Registry Module
* Program Subscriptions Module
* Warehouse Module

### Monthly Schedule amortization of loan to be collected
- per barangay
- per organization

Chart monthly revenue percentage
- Store update
- suppliers index
- Uploading of stocks

Check paginations on entries index page
activate/ deactivate accounts
edit tin number of member
edit address of member
add policies for pages

cash disbursement per employee DONE
cash receiveds per employee done

cash disbursement voucher printable pdf

add beneficiaries of member ( relationships)
familymenber
belongs_to member
relation [:mother, :father, :daughter, :son, :grandmother, :grandfather, :brother, :sister]

Implement TimeDeposit done

Entry of days worked of employee
Employee Contributions

Document Management

Programs and program subscription of member


This is the idea that Coop Catalyst was built on – that cooperatives should have easy, centralized access to information about their members and that it shouldn’t be so hard for them to use that information to improve the relationship and improve the services for their members.

background job kaltas payment of program from members who subscribed

##Accounting
  separate account for each programs
  print pdf of time deposit


  sales return
    sales return account
    merchandise inventory

    cost of goods sold
    cash on hand


what do you do if term exceeds 36 months
rename factories to _factory.rb
add faker to factories

sales to ifedeco
your own cic
  know members credit data
  know if a real property is collateralled already



refactor break contract feature
remove dragon fly gem
remove member_avatar method







add collector accounts

add organization for filter of loans
show charts on aging loans

update loan schedule dates if disbursed DONE

update policies of every action/page


WIP: Select dropdown for capybara


Review Fund Transfer transactions

revire Loan Charges / subscription charges


layout receipt
user pos printer


validates fullname of member


Settigns page for savings accounts for transferring deposit, closing account
, adjustments

FIX management settings page

filter members per barangay, per municipality export to excel


Fix time deposits on transactio nsummary
Statement of accounts per member
refactor transactions summary pdf
