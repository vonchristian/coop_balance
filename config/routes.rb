Rails.application.routes.draw do
  devise_for :users, controllers: { sessions: 'users/sessions', registrations: "management_module/settings/employees"}

  authenticated :user do
    root :to => 'members#index'
  end

  resources :customer_registrations, only: [:new, :create]
  resources :home, only: [:index]

  resources :accounting_module, only: [:index]
  namespace :accounting_module do
    resources :adjusting_entries, only: [:new, :create]
    resources :interests_earned_postings, only: [:create]
    resources :schedules, only: [:index]
    resources :entry_line_items, only: [:new, :create, :destroy]
    resources :entry_processings, only: [:create]
    resources :financial_condition_comparisons, only: [:new, :create, :show]
    resources :reports, only: [:index]
    namespace :reports do
      resources :trial_balances,       only: [:index]
      resources :proofsheets,          only: [:index]
      resources :income_statements,    only: [:index]
      resources :balance_sheets,       only: [:index]
      resources :financial_conditions, only: [:index]
    end
    resources :offices, only: [:index, :show]
    resources :settings, only: [:index]
    resources :loan_protection_fund_configs, only: [:new, :create]
    resources :accounts do
      resources :activations, only: [:create], module: :accounts
      resources :deactivations, only: [:create], module: :accounts
      resources :reports, only: [:index], module: :accounts
      resources :settings, only: [:index], module: :accounts
      resources :entries, only: [:index], module: :accounts
    end
    resources :assets, controller: 'accounts', type: 'AccountingModule::Asset'
    resources :entries do
      resources :clearances, only: [:create], module: :entries
    end
    resources :debit_amounts, only: [:edit, :update]
    resources :credit_amounts, only: [:edit, :update]

  end

  resources :loans_module, only: [:index]
  namespace :loans_module do
    resources :voucher_amounts, shallow: true do
      resources :amount_adjustments, only: [:new, :create], module: :loan_applications
    end
    resources :archived_loans, only: [:index]

    resources :disbursement_vouchers, only: [:create]
    namespace :monitoring do
      resources :disbursements, only: [:index]
      resources :loan_product_portfolios, only: [:index]
      resources :loans_per_barangays, only: [:index]
      resources :loan_payments, only: [:index]
      resources :metrics, only: [:index]
    end
    resources :search_results, only: [:index]
    resources :schedules, only: [:index, :show]
    resources :amortization_schedules, only: [:show], module: :schedules
    namespace :reports do
      resources :loan_releases, only: [:index]
      resources :loan_protection_funds, only: [:index]
      resources :loan_collections, only: [:index]
    end
    resources :member_borrowers, only: [:index, :show]
    resources :employee_borrowers, only: [:index, :show]
    resources :organization_borrowers, only: [:index, :show]

    resources :reports, only: [:index]
    resources :loan_registries, only: [:new, :create]
    resources :aging_loans, only: [:index, :show]
    resources :loan_calculator, only: [:index]
    resources :disbursement_vouchers, only: [:create], module: :loan_applications
    resources :loan_applications, only: [:new, :create, :show, :destroy] do
      resources :capital_build_up_processings,       only: [:new, :create], module: :loan_applications
    end
    resources :dashboard, only: [:index]
    resources :loan_products, except:[:destroy] do
      resources :interest_configurations, only: [:new, :create], module: :loan_products
      resources :penalty_configurations, only: [:new, :create], module: :loan_products
      resources :loan_product_charges, only: [:new, :create], module: :loan_products
      resources :loans, only: [:index], module: :loan_products
    end
    resources :adjustments, only: [:destroy]
    resources :loan_charges do
      resources :adjustments, only: [:new, :create], module: :loan_charges
      resources :payment_schedules, only: [:new, :create], module: :schedules
    end

    resources :loans do
      resources :loan_penalty_discounts, only: [:new, :create], module: :loans
      resources :loan_interest_discounts, only: [:new, :create], module: :loans

      resources :first_notices, only: [:show], module: :notices
      resources :archivings, only: [:create], module: :loans
      resources :savings_account_deposits,      only: [:new, :create], module: :loans
      resources :terms,                         only: [:new, :create], module: :loans
      resources :interest_postings,             only: [:new, :create], module: :loans
      resources :penalty_postings,              only: [:new, :create], module: :loans
      resources :interest_rebate_postings,      only: [:new, :create], module: :loans
      resources :previous_loan_payments,        only: [:new, :create]
      resources :store_credit_payments,         only: [:new, :create]
      resources :loan_protection_funds,         only: [:new, :create]
      resources :amortization_schedules,        only: [:index],        module: :loans
      resources :first_notices,                 only: [:new, :create]
      resources :processings,                   only: [:create]
      resources :additional_charges,            only: [:new, :create]
      resources :borrower_subscription_charges, only: [:new, :create]
      resources :payments,                      only: [:new, :create]
      resources :losses,                        only: [:new, :create], module: :loans
      resources :tracking_numbers,              only: [:edit, :update], module: :loans
    end
    resources :members, only: [:index, :show] do
      resources :loan_applications, only: [:new, :create], module: :member_loans
      resources :real_properties, only: [:new, :create]
    end
    resources :settings, only: [:index]
    resources :charges, only: [:new, :create]
    resources :loan_product_charges, only: [:new, :create]
    resources :loan_calculator, only: [:index]
    resources :notices, only: [:index, :show]
  end
  resources :share_capitals do
    resources :barangays, only: [:edit, :update], module: :share_capitals
    resources :settings, only: [:index], module: :share_capitals
    resources :mergings, only: [:create], module: :share_capitals
    resources :merging_line_items, only: [:new, :create], module: :share_capitals
    resources :capital_build_ups, only: [:new, :create], module: :share_capitals
    resources :account_closings, only: [:new, :create], module: :share_capitals
    resources :offices, only: [:edit, :update], module: :share_capitals
    resources :balance_transfers, only: [:new, :create], module: :share_capitals
  end
  resources :members do
    resources :beneficiaries, only: [:new, :create], module: :members
    resources :merging_line_items, only: [:new, :create], module: :members
    resources :mergings,         only: [:create],         module: :members
    resources :contacts,         only: [:new, :create],                 module: :members
    resources :tins,             only: [:new, :create],                 module: :members
    resources :relationships,    only: [:new, :create],                 module: :members
    resources :time_deposits,    only: [:index, :new, :create],         module: :members
    resources :tins,             only: [:new, :create],                 module: :members
    resources :offices,          only: [:new, :create, :edit, :update], module: :members
    resources :addresses,        only: [:new, :create, :edit, :update], module: :members
    resources :memberships,      only: [:edit, :update, :new, :create], module: :members
    resources :info,             only: [:index],                        module: :members
    resources :settings,         only: [:index],                        module: :members
    resources :loans,            only: [:index, :new, :create],         module: :members
    resources :real_properties,  only: [:index, :new, :create],         module: :members
    resources :share_capitals,   only: [:index, :new, :create],         module: :members
    resources :occupations,      only: [:new, :create],                 module: :members
    resources :share_capitals,   only: [:index, :new, :create]
    resources :savings_accounts, only: [:index, :new, :create],         module: :members
    resources :subscriptions,    only: [:index],                        module: :members
    resources :program_subscriptions,    only: [:create],                       module: :members

    resources :purchases,        only: [:index, :show],                 module: :members
    resources :account_mergings, only: [:new, :create],                 module: :members
    resources :signature_specimens, module: :members
    resources :avatars, module: :members
    collection { post :import_member_profile}
  end
  resources :member_registrations, only: [:new, :create]

  namespace :management_module do
    resources :account_budgets, only: [:index, :new, :create]
    resources :savings_account_registries, only: [:new, :create]
    resources :share_capital_registries, only: [:new, :create]
    resources :loan_registries, only: [:new, :create]
    resources :time_deposit_registries, only: [:new, :create]
    resources :member_registries, only: [:create]

    namespace :settings do
      resources :generals, only: [:index]
      resources :account_budgets, only: [:index]
      resources :cooperative_products, only: [:index]
      resources :configurations, only: [:index]
      resources :data_migrations, only: [:index]
      resources :loan_products, only: [:new, :create]
      resources :store_fronts, only: [:new, :create]
      resources :cooperatives, only: [:edit, :update, :show] do
        resources :offices, only: [:new, :create]
      end
      resources :savings_account_configs, only: [:new, :create]
      resources :time_deposit_products, only: [:new, :create, :show]
    end
    resources :accounting, only: [:index]
    resources :share_capitals, only: [:index, :show]
    resources :employees, only: [:index, :show]
    resources :savings, only: [:index, :show]
    resources :time_deposits, only: [:index, :show]
    resources :entries, only: [:index, :show]
    resources :accounts, only: [:index, :show]
    resources :employees, only: [:new, :create], module: :settings

    resources :share_capital_products, only: [:new, :create], module: :settings do
      resources :shares, only: [:new, :create]
    end
    resources :saving_products, only: [:new, :create], module: :settings
    resources :programs, only: [:new, :create], module: :settings
    resources :settings, only: [:index]
    resources :members, only: [:index, :show, :new, :create] do
      collection { post :import }
      end
    resources :grace_periods, only: [:new, :create], module: :settings
  end
  resources :teller_module, only: [:index]
  namespace :teller_module do

    resources :members, only: [:index, :show, :new, :create] do
      resources :savings, only: [:new, :create]
      resources :time_deposits, only: [:new, :create]
    end

    resources :share_capitals, only: [:index, :show] do
      resources :capital_build_ups, only: [:new, :create]
    end

    resources :entries, only: [:index, :show]
  end

  resources :users, only: [:show]

  namespace :store_front_module do
    resources :inventories, only: [:index, :show] do
      resources :sales,            only: [:index], module: :inventories
      resources :sales_returns,    only: [:index], module: :inventories
      resources :purchase_returns, only: [:index], module: :inventories
      resources :spoilages,        only: [:index], module: :inventories
      resources :settings,         only: [:index], module: :inventories
      resources :internal_uses,    only: [:index], module: :inventories
      resources :stock_transfers,  only: [:index], module: :inventories
    end
    resources :purchases,                only: [:index, :show, :create],   module: :orders
    resources :sales,                    only: [:index, :show, :create],   module: :orders
    resources :credit_sales,             only: [:index, :show, :create],   module: :orders
    resources :sales_returns,            only: [:index, :show, :create],   module: :orders
    resources :purchase_returns,         only: [:index, :show, :create],   module: :orders
    resources :spoilages,                only: [:index, :show, :create],   module: :orders
    resources :internal_uses,            only: [:index, :show, :create],   module: :orders
    resources :stock_transfers,          only: [:index, :show, :create],   module: :orders
    resources :received_stock_transfers, only: [:index, :show, :create],   module: :orders

    resources :purchase_line_items,                only: [:new, :create, :destroy], module: :line_items
    resources :sales_line_items,                   only: [:new, :create, :destroy], module: :line_items
    resources :sales_return_line_items,            only: [:new, :create, :destroy], module: :line_items
    resources :purchase_return_line_items,         only: [:new, :create, :destroy], module: :line_items
    resources :credit_sales_line_items,            only: [:new, :create, :destroy], module: :line_items
    resources :spoilage_line_items,                only: [:new, :create, :destroy], module: :line_items
    resources :stock_transfer_line_items,          only: [:new, :create, :destroy], module: :line_items
    resources :internal_use_line_items,            only: [:new, :create, :destroy], module: :line_items
    resources :received_stock_transfer_line_items, only: [:new, :create, :destroy], module: :line_items

    resources :sales_reports,             only: [:index], module: :reports
    resources :sales_clerk_reports,       only: [:index], module: :reports
    resources :sales_clerk_sales_reports, only: [:index], module: :reports
    resources :purchases_reports,         only: [:index], module: :reports
    resources :spoilages_reports,         only: [:index], module: :reports

    resources :suppliers,      only: [:index, :new, :create]
    resources :employees,      only: [:show]
    resources :settings,       only: [:index]
    resources :reports,        only: [:index]
    resources :search_results, only: [:index]
    resources :members,        only: [:index, :show, :new, :create]

    resources :products, only: [:index, :show, :new, :create] do
      resources :purchases,                only: [:index, :new, :create], module: :products
      resources :sales,                    only: [:index],                module: :products
      resources :purchase_returns,         only: [:index],                module: :products
      resources :sales_returns,            only: [:index],                module: :products
      resources :settings,                 only: [:index],                module: :products
      resources :spoilages,                only: [:index],                module: :products
      resources :internal_uses,            only: [:index],                module: :products
      resources :stock_transfers,          only: [:index],                module: :products
      resources :received_stock_transfers, only: [:index],                module: :products
      resources :unit_of_measurements, only: [:new, :create]
    end
    resources :unit_of_measurements, shallow: true do
      resources :mark_up_prices, only: [:new, :create]
    end
    resources :customers, only: [:index, :show] do
      resources :sales_orders, only: [:index], module: :customers
    end
  end

  resources :schedules, only: [:index, :show]
  resources :treasury_module, only: [:index]
  namespace :treasury_module do
    resources :savings_accounts, only: [:new, :create]
    resources :disbursements, only: [:index]
    resources :cash_receipts, only: [:index]
    resources :disbursement_line_items, only: [:new, :create, :destroy]
    resources :cash_receipt_line_items, only: [:new, :create, :destroy]
    resources :disbursement_processings, only: [:create]
    resources :cash_receipt_processings, only: [:create]

    resources :employees, only: [:index, :show] do
      resources :remittances, only: [:new, :create]
      resources :fund_transfers, only: [:new, :create]
    end
    resources :search_results, only: [:index]
    # resources :savings_accounts, only: [:index, :show] do
    #   resources :deposits, only: [:new, :create]
    # end
    resources :entries, only: [:index, :show]
  end
  resources :savings_accounts_dashboards, only: [:index]
  resources :savings_accounts_below_minimum_balances, only: [:index]
  resources :share_capitals_below_minimum_balances, only: [:index]
namespace :share_capitals_section do
    resources :dashboards, only: [:index]
  end



  resources :savings_accounts, only: [:index, :show] do
    resources :balance_transfers, only: [:new, :create], module: :savings_accounts
    resources :settings,          only: [:index],        module: :savings_accounts
    resources :account_mergings,  only: [:create], module: :savings_accounts
    resources :merging_line_items, only: [:new, :create, :destroy], module: :savings_accounts
    resources :deposits,          only: [:new, :create], module: :savings_accounts
    resources :withdrawals,       only: [:new, :create], module: :savings_accounts
    resources :account_closings,  only: [:new, :create], module: :savings_accounts
    resources :barangay_settings,  only: [:edit, :update], module: :savings_accounts

  end

  resources :search_results, only: [:index, :show]
  resources :occupations, only: [:index, :show]
  resources :disbursements, only: [:index, :show, :new, :create]
  resources :collections, only: [:index, :show]
  resources :suppliers, only: [:index, :show, :new, :create, :edit, :update] do
      resources :vouchers, only: [:index, :show, :new, :create], module: :suppliers
      resources :purchases, only: [:index, :new, :create], module: :suppliers
      resources :purchase_processings, only: [:create], module: :suppliers
      resources :delivery_vouchers, only: [:create], module: :suppliers
      resources :purchase_returns, only: [:index, :new, :create], module: :suppliers
      resources :amounts, only: [:create, :destroy], module: :suppliers
    end
  resources :registries, only: [:create]

  resources :programs, only: [:index, :show] do
    resources :payments, only: [:new, :create], module: :programs
  end
  resources :time_deposits, only: [:index, :show] do
    resources :adjusting_entries, only: [:new, :create], module: :time_deposits
    resources :withdrawals, only: [:new, :create], module: :time_deposits
    resources :term_extensions, only: [:new, :create], module: :time_deposits
    resources :break_contracts, only: [:new, :create], module: :time_deposits
    resources :settings, only: [:index], module: :time_deposits
    resources :earned_interests, only: [:new, :create], module: :time_deposits

  end
  resources :employees, only: [:index, :show, :edit, :update] do
    resources :info, only: [:index], module: :employees
    resources :blotters, only: [:index], module: :employees
    resources :cash_disbursements, only: [:index], module: :employees
    resources :cash_receipts, only: [:index], module: :employees
    resources :loans, only: [:new, :create], module: :employees
    resources :memberships, only: [:new, :create, :edit, :update], module: :employees
    resources :cash_on_hand_accounts, only: [:edit, :update], module: :employees
    resources :time_deposits, only: [:index, :new, :create], module: :employees
    resources :savings_accounts, only: [:index, :new, :create], module: :employees
    resources :share_capitals, only: [:index, :new, :create], module: :employees
    resources :entries, only: [:index, :show], module: :employees
    resources :remittances, only: [:new, :create], module: :employees
    resources :cash_transfers, only: [:new, :create], module: :employees
    resources :vault_fund_transfers, only: [:new, :create], module: :employees
    resources :reports, only: [:index], module: :employees
    resources :vouchers, only: [:index, :new, :create], module: :employees
    resources :amounts, only: [:new, :create, :destroy], module: :employees
    resources :orders, only: [:index], module: :employees
    resources :loans, only: [:index], module: :employees
  end
  resources :loans, only: [:index, :show] do
    resources :notes,                 only: [:index, :new, :create],         module: :loans
    resources :barangays,             only: [:edit, :update],        module: :loans
    resources :settings,              only: [:index],                module: :loans
    resources :real_properties,       only: [:new, :create, :show],  module: :loans
    resources :loan_co_makers,        only: [:index, :new, :create], module: :loans
    resources :approvals,             only: [:new, :create],         module: :loans
    resources :disbursement_vouchers, only: [:new, :create, :show],  module: :loans
    resources :payments,              only: [:index, :new, :create], module: :loans
    resources :collaterals,           only: [:index, :new, :create], module: :loans
  end

  resources :vouchers, only: [:index, :show, :destroy] do
    resources :disbursements, only: [:new, :create], module: :vouchers
    resources :loan_disbursements, only: [:new, :create], module: :vouchers

  end
  resources :voucher_amounts, only: [:destroy]
  resources :bank_accounts, only: [:index, :show, :new, :create, :edit, :update] do
    resources :deposits, only: [:new, :create], module: :bank_accounts
    resources :withdrawals, only: [:new, :create], module: :bank_accounts
    resources :bank_charges, only: [:new, :create], module: :bank_accounts
    resources :bank_earned_interests, only: [:new, :create], module: :bank_accounts
  end

  resources :calendars, only: [:index, :show]
  resources :organizations, only: [:index, :show, :new, :create] do
    resources :members, only: [:new, :create], module: :organizations
    resources :loans, only: [:index], module: :organizations
    resources :reports, only: [:index], module: :organizations
  end

  resources :membership_applications, only: [:new, :create, :show] do
    resources :contributions, only: [:new, :create], module: :membership_applications
    resources :payments, only: [:new, :create], module: :membership_applications
  end
  resources :cooperatives, only: [:show]
  resources :offices, only: [:index, :show] do
      resources :sections, only: [:new, :create], module: :offices
    end

  mount ActionCable.server => '/cable'
  resources :monitoring, only: [:index]
  namespace :monitoring do
    resources :savings_products, only: [:index]
    resources :loan_products, only: [:index]
    resources :store_fronts, only: [:index]
  end
  resources :filtered_loans, only: [:index], module: :loans_module
  resources :matured_loans, only: [:index],  module: :loans_module
  resources :barangays, only: [:index, :show] do
    resources :loans, only: [:index], module: :barangays
    resources :savings, only: [:index], module: :barangays
    resources :members, only: [:index], module: :barangays
  end
  resources :memberships, only: [:index, :show] do
    resources :time_deposits, only: [:new, :create], module: :memberships
    resources :share_capital_subscriptions, only: [:new, :create], module: :memberships
    resources :program_subscriptions, only: [:create], module: :memberships do
      resources :payments, only: [:new, :create], module: :program_subscriptions
    end
  end
  resources :cooperators, only: [:show]
  namespace :cooperators do
    resources :accounts, only: [:show]
    resources :sign_ups, only: [:new, :create]
  end
  resources :program_subscriptions, shallow: true do
      resources :payments, only: [:new, :create], module: :program_subscriptions
    end
  resources :metrics, only: [:index]
  namespace :metrics do
    resources :savings_accounts, only: [:index, :create]
  end
  namespace :reports do
    resources :audit_reports, only: [:index]
  end
  resources :cooperative_services, only: [:index, :new, :create, :show] do
    resources :balance_sheets,  only: [:index],        module: :cooperative_services
    resources :settings,        only: [:index],        module: :cooperative_services

    resources :accounts,        only: [:new, :create], module: :cooperative_services do
      resources :activations,   only: [:create],       module: :accounts
      resources :deactivations, only: [:create],       module: :accounts
    end
  end
  namespace :coop_module do
    resources :search_results, only: [:index]
  end
  devise_for :member_accounts, controllers: { sessions: 'member_accounts/sessions', registrations: 'member_accounts/registrations'}
unauthenticated :user do
    root :to => 'home#index', :constraints => lambda { |request| request.env['warden'].user.nil? }, as: :unauthenticated_root
  end
end
