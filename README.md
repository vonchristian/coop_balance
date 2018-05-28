class InterestPosting
  def post_interests_earned(options={})
    if !options[:savings_account].interest_posted?(date: options[:date])
      AccountingModule::Entry.create!(
        origin: options[:employee].office,
        recorder: options[:employee],
        description: 'Interest expense on savings deposits',
        entry_date: options[:date],
        debit_amounts_attributes: [
          account: options[:savings_account].saving_product_interest_expense_account,
          amount: amount_for(savings_account: options[:savings_account], date: options[:date]),
          commercial_document: options[:savings_account] ],
      credit_amounts_attributes: [
        account: options[:savings_account].saving_product_account,
        amount: amount_for(savings_account: options[:savings_account], date: options[:date]),
        commercial_document: options[:savings_account]]
      )
    end
  end

  def amount_for(options={})
    options[:savings_account].balance *
    options[:savings_account].saving_product_quarterly_interest_rate *
    number_of_days(date: options[:date])
  end

  def number_of_days(options={})
    (((options[:date].end_of_quarter - options[:date].beginning_of_quarter)/86400.0).to_i) / 365
  end
end



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


The man doesnt know how to give upkms316
in 6 months (july 2018)
10 coops sign up


rename store_front_module to store_front_module
remove status of savings
if savings closed? the same with share capitals closed


At CoopCatalyst, we're all about automation. We're on a mission to make cooperative management fast and easy. Driven by numerous conversations with our customers and our own experiences, we've built a new CI feature that can automatically parallelize any test suite and cut its runtime to just a few minutes - Semaphore Boosters. Learn more and try it out.



BIG REDESIGN
Rename store_front_module to store_front_module DONE
remove entry_type


Research
include modules rails

entry for loan disbursement
if earned interest income
unearned interest income
amortized interest

render :back


STORE CART
<% @sales_order_line_items.each do |line_item| %>
                  <tr>
                    <td>
                      <%= line_item.quantity %> <%= line_item.unit_of_measurement_code %>
                    </td>
                    <td width="300px"><%= line_item.name.try(:titleize) %> <span class="text-muted"><%= line_item.barcode %></span>
                    </td>
                    <td>
                      <span class="pull-right">
                        <%= number_to_currency line_item.unit_cost %></td>
                      </span>
                    <td>
                      <span class="pull-right"><%=number_to_currency line_item.total_cost %></span>
                    </td>
                    <td>
                    <%= link_to store_front_module_sales_order_line_item_path(line_item), method: :delete do %>
                      <span class="fa fa-trash"></span>
                    <% end %>
                    </td>
                  </tr>
                <% end %>


add stats on product show page

