Rails.application.routes.draw do
  devise_for :users, controllers: { sessions: 'users/sessions', registrations: "management_module/settings/employees"}

  authenticated :user do
    root :to => 'members#index'
  end
  resources :home, only: [:index]

  resources :accounting_module, only: [:index]
  namespace :accounting_module do
    resources :commercial_document_adjusting_entry_line_items, only: [:new, :create, :destroy], module: :entries
    resources :per_employee_entries, only: [:index], module: :entries
    resources :per_office_entries, only: [:index], module: :entries
    resources :scheduled_entries, only: [:index]
    resources :interest_expense_vouchers, only: [:show]

    namespace :scheduled_entries do
      resources :savings_accounts_interest_postings, only: [:new, :create]
      resources :share_capital_dividend_postings, only: [:new, :create]
    end

    resources :cash_receipts, module: :entries,     only: [:index]
    resources :cash_disbursements, module: :entries, only: [:index]
    resources :journal_entry_vouchers,  module: :entries, only: [:index]

    resources :entry_line_item_vouchers, only: [:create, :show, :destroy], module: :entries do
      resources :confirmations, only: [:create], module: :entry_line_item_vouchers
    end

    resources :interests_earned_postings, only: [:create]
    resources :entry_line_items, only: [:new, :create, :destroy]
    resources :entry_processings, only: [:create]
    resources :financial_condition_comparisons, only: [:new, :create, :show]
    resources :reports, only: [:index]

    namespace :reports do
      resources :entries, only: [:index]
      resources :net_income_distributions, only: [:index]
      resources :trial_balances,       only: [:index]
      resources :proofsheets,          only: [:index]
      resources :income_statements,    only: [:index]
      resources :balance_sheets,       only: [:index]
      resources :financial_conditions, only: [:index]
    end

    resources :settings, only: [:index]

    resources :accounts, except: [:destroy] do
      resources :activations, only: [:create], module: :accounts
      resources :deactivations, only: [:create], module: :accounts
      resources :reports, only: [:index], module: :accounts
      resources :settings, only: [:index], module: :accounts
      resources :entries, only: [:index], module: :accounts
    end

    resources :assets, controller: 'accounts', type: 'AccountingModule::Asset'

    resources :entries do
      resources :cancellations, only: [:new, :create], module: :entries
    end

    resources :debit_amounts, only: [:edit, :update]
    resources :credit_amounts, only: [:edit, :update]

  end

  resources :loans_module, only: [:index]

  namespace :loans_module do
    resources :amortization_schedules, only: [:index, :show]
    resources :amortization_schedule_date_filters, only: [:index]

    resources :organizations, only: [:index, :show] do
      resources :loans, only: [:index], module: :organizations
      resources :reports, only: [:index], module: :organizations
    end

    resources :archived_loans, only: [:index]
    resources :disbursement_vouchers, only: [:create]

    namespace :monitoring do
      resources :metrics, only: [:index]
    end

    resources :search_results, only: [:index]

    namespace :reports do
      resources :loan_releases, only: [:index]
      resources :loan_collections, only: [:index]
      resources :aging_loans, only: [:index]
    end

    resources :member_borrowers, only: [:index, :show]
    resources :reports, only: [:index]
    resources :aging_loans, only: [:index, :show]

    resources :loan_applications, only: [:index, :new, :create, :show, :destroy] do
      resources :capital_build_up_processings,       only: [:new, :create], module: :loan_applications
      resources :savings_account_deposit_processings, only: [:new, :create], module: :loan_applications
      resources :previous_loan_payment_processings,   only: [:new, :create], module: :loan_applications
      resources :vouchers, only: [:new, :create, :show, :destroy], module: :loan_applications
      resources :amortization_schedules, only: [:index], module: :loan_applications
      resources :voucher_confirmations, only: [:create], module: :loan_applications
      resources :loan_amounts, only: [:new, :create], module: :loan_applications
      resources :voucher_amounts,       only: [:new, :create, :edit, :update, :destroy], module: :loan_applications

    end

    resources :dashboard, only: [:index]

    resources :loan_products, only:[:index, :show] do
      resources :loans, only: [:index], module: :loan_products
      resources :reports, only: [:index], module: :loan_products
    end

    resources :loans, only: [:index, :show] do
      resources :loss_vouchers, only: [:show], module: :loans
      resources :interests, only: [:index], module: :loans
      resources :penalties, only: [:index], module: :loans

      resources :co_makers,                 only: [:new, :create], module: :loans
      resources :past_due_vouchers,              only: [:new, :create, :show, :destroy], module: :loans
      resources :past_due_voucher_confirmations, only: [:create],                        module: :loans
      resources :organizations,                  only: [:edit, :update],                 module: :loans
      resources :loan_penalty_discounts,         only: [:new, :create],                  module: :loans
      resources :loan_interest_discounts,        only: [:new, :create],                  module: :loans
      resources :archivings,                     only: [:create],                        module: :loans

      resources :terms,                         only: [:new, :create], module: :loans
      resources :interest_postings,             only: [:new, :create], module: :loans
      resources :penalty_postings,              only: [:new, :create], module: :loans
      resources :interest_rebate_postings,      only: [:new, :create], module: :loans
      resources :amortization_schedules,        only: [:index],        module: :loans

      resources :payments,                      only: [:new, :create], module: :loans
      resources :losses,                        only: [:new, :create], module: :loans
      resources :tracking_numbers,              only: [:edit, :update], module: :loans
    end
  end
  resources :share_capitals, only: [:index, :show] do
    resources :balance_transfer_destination_accounts, only: [:new, :create], module: :share_capitals

    resources :vouchers, only: [:show, :destroy], module: :share_capitals do
      resources :confirmations, only: [:create]
    end

    resources :balance_transfer_vouchers, only: [:show, :destroy], module: :share_capitals do
      resources :confirmations, only: [:create]
    end

    resources :barangays, only: [:edit, :update], module: :share_capitals
    resources :settings, only: [:index],          module: :share_capitals
    resources :mergings, only: [:create],         module: :share_capitals
    resources :merging_line_items, only: [:new, :create, :destroy], module: :share_capitals
    resources :capital_build_ups, only: [:new, :create],  module: :share_capitals
    resources :account_closings, only: [:new, :create],   module: :share_capitals
    resources :offices, only: [:edit, :update],           module: :share_capitals
    resources :balance_transfers, only: [:new, :create],  module: :share_capitals
  end

  resources :members, only: [:index, :show, :edit, :update, :destroy] do
    resources :organizations,         only: [:new, :create],                 module: :members
    resources :beneficiaries,         only: [:new, :create, :destroy],       module: :members
    resources :merging_line_items,    only: [:new, :create],                 module: :members
    resources :mergings,              only: [:create],                       module: :members
    resources :contacts,              only: [:new, :create],                 module: :members
    resources :tins,                  only: [:new, :create],                 module: :members
    resources :time_deposits,         only: [:index, :new, :create],         module: :members
    resources :tins,                  only: [:new, :create],                 module: :members
    resources :offices,               only: [:edit, :update],                module: :members
    resources :addresses,             only: [:new, :create],                 module: :members
    resources :memberships,           only: [:edit, :update, :new, :create], module: :members
    resources :info,                  only: [:index],                        module: :members
    resources :settings,              only: [:index],                        module: :members
    resources :loans,                 only: [:index],                        module: :members
    resources :share_capitals,        only: [:index],                        module: :members
    resources :occupations,           only: [:new, :create],                 module: :members
    resources :savings_accounts,      only: [:index],                        module: :members
    resources :subscriptions,         only: [:index],                        module: :members
    resources :program_subscriptions, only: [:create],                       module: :members
    resources :sales,                 only: [:index, :show],                 module: :members
    resources :credit_sales_line_items, only: [:new, :create, :destroy],     module: :members
    resources :account_mergings,      only: [:new, :create],                 module: :members
    resources :signature_specimens,   only: [:create],                       module: :members
    resources :avatars,               only: [:update],                       module: :members
  end

  resources :member_registrations, only: [:new, :create]
  resources :organization_registries, only: [:new, :create], module: [:registries]
  resources :savings_account_registries, only: [:create],    module: [:registries]
  resources :share_capital_registries, only: [:create],      module: [:registries]
  resources :loan_registries, only: [:create],               module: [:registries]
  resources :time_deposit_registries, only: [:create],       module: [:registries]
  resources :member_registries, only: [:create],             module: [:registries]
  resources :bank_account_registries, only: [:create],       module: [:registries]

  namespace :management_module do
    resources :account_budgets, only: [:index, :new, :create]
    resources :loan_protection_plan_providers, only: [:new, :create], module: :configurations

    namespace :settings do
      resources :general, only: [:index]
      resources :offices, only: [:index]
      resources :saving_products, only: [:index]
      resources :share_capital_products, only: [:index]
      resources :time_deposit_products, only: [:index]
      resources :programs, only: [:index]
      resources :store_fronts, only: [:index]
      resources :cooperative_services, only: [:index]





      resources :account_budgets, only: [:index]
      resources :cooperative_products, only: [:index]
      resources :configurations, only: [:index]
      resources :data_migrations, only: [:index]

      resources :loan_products, only: [:index, :new, :create, :edit, :update] do
        resources :charges, only: [:new, :create, :edit, :update], module: :loan_products
        resources :interest_configurations, only: [:new, :create], module: :loan_products
        resources :penalty_configurations, only: [:new, :create],  module: :loan_products
        resources :deactivations, only: [:create],                 module: :loan_products
        resources :activations, only: [:create],                   module: :loan_products
      end

      resources :store_fronts, only: [:new, :create]
      resources :net_income_distributions, only: [:new, :create]

      resources :cooperatives, only: [:edit, :update, :show] do
        resources :offices, only: [:new, :create]
      end

      resources :time_deposit_products, only: [:new, :create, :show, :edit, :update]
    end

    resources :employees, only: [:index, :show]
    resources :employees, only: [:new, :create], module: :settings

    resources :share_capital_products, only: [:new, :create, :edit, :update], module: :settings do
      resources :shares, only: [:new, :create]
    end

    resources :saving_products, only: [:new, :create, :edit, :update], module: :settings
    resources :programs, only: [:new, :create], module: :settings
    resources :settings, only: [:index]
    resources :grace_periods, only: [:new, :create], module: :settings
  end

  resources :teller_module, only: [:index]
  resources :users, only: [:show]

  namespace :store_front_module do
    resources :stock_registry_processings, only: [:create]
    resources :stock_registries, only: [:create, :show], module: :settings
    resources :suppliers, only: [:index, :show, :new, :create] do
      resources :vouchers, only: [:index, :show, :create, :destroy], module: :suppliers
      resources :voucher_confirmations, only: [:create], module: :suppliers
      resources :purchase_deliveries, only: [:index, :new, :create], module: :suppliers
      resources :purchase_returns, only: [:index, :new, :create], module: :suppliers
      resources :voucher_amounts, only: [:new, :create, :destroy], module: :suppliers
      resources :purchase_line_items, only: [:new, :create], module: :suppliers
    end

    resources :inventories, only: [:index, :show] do
      resources :sales,            only: [:index], module: :inventories
      resources :sales_returns,    only: [:index], module: :inventories
      resources :purchase_returns, only: [:index], module: :inventories
      resources :spoilages,        only: [:index], module: :inventories
      resources :settings,         only: [:index], module: :inventories
      resources :internal_uses,    only: [:index], module: :inventories
      resources :stock_transfers,  only: [:index], module: :inventories
    end

    resources :purchase_orders,          only: [:index, :show, :create], module: :orders
    resources :sales,              only: [:index, :show, :create], module: :orders
    resources :credit_sales,       only: [:create],                module: :orders
    resources :sales_returns,      only: [:index, :show, :create], module: :orders
    resources :purchase_returns,   only: [:index, :create],        module: :orders
    resources :spoilages,          only: [:index, :create],        module: :orders
    resources :stock_transfers,    only: [:index],                 module: :orders

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

    resources :employees,      only: [:show]
    resources :settings,       only: [:index]
    resources :reports,         only: [:index]
    resources :search_results, only: [:index]

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

    resources :unit_of_measurements, only: [:show] do
      resources :mark_up_prices, only: [:new, :create]
    end

    resources :customers, only: [:index, :show] do
      resources :sales_orders, only: [:index], module: :customers
    end
  end

  resources :schedules, only: [:index, :show]
  resources :treasury_module, only: [:index]

  namespace :treasury_module do
    namespace :summaries do
      resources :cash_books, only: [:index]
      resources :loans, only: [:index]
    end
    resources :cash_accounts, only: [:index, :show] do
      resources :reports, only: [:index],                                       module: :cash_accounts
      resources :cash_receipt_line_items, only: [:new, :create, :destroy],      module: :cash_accounts
      resources :cash_disbursement_line_items, only: [:new, :create, :destroy], module: :cash_accounts
      resources :cash_disbursement_vouchers, only: [:show],                     module: :cash_accounts
    end

    resources :disbursements, only: [:index]
    resources :cash_receipts, only: [:index]
    resources :cash_disbursement_voucher_processings, only: [:create]
    resources :cash_receipt_voucher_processings, only: [:create]

    resources :cash_disbursement_vouchers, only: [:show, :destroy] do
      resources :confirmations, only: [:create], module: :cash_disbursement_vouchers
    end

    resources :cash_receipt_vouchers, only: [:show, :destroy] do
      resources :confirmations, only: [:create], module: :cash_receipt_vouchers
    end
  end

  resources :savings_accounts_dashboards, only: [:index]
  resources :savings_accounts_below_minimum_balances, only: [:index]
  resources :share_capitals_below_minimum_balances, only: [:index]

  namespace :share_capitals_section do
    resources :dashboards, only: [:index]
  end

  resources :savings_accounts, only: [:index, :show] do
    resources :balance_transfer_destination_accounts, only: [:new, :create], module: :savings_accounts
    resources :balance_transfer_vouchers, only: [:show],            module: :savings_accounts
    resources :deposit_vouchers, only: [:show, :destroy],           module: :savings_accounts
    resources :withdrawal_vouchers, only: [:show, :destroy],        module: :savings_accounts
    resources :account_closing_vouchers, only: [:show, :destroy],   module: :savings_accounts
    resources :balance_transfers, only: [:new, :create],            module: :savings_accounts
    resources :settings,          only: [:index],                   module: :savings_accounts
    resources :account_mergings,  only: [:create],                  module: :savings_accounts
    resources :merging_line_items, only: [:new, :create, :destroy], module: :savings_accounts
    resources :deposits,          only: [:new, :create],            module: :savings_accounts
    resources :withdrawals,       only: [:new, :create],            module: :savings_accounts
    resources :account_closings,  only: [:new, :create],            module: :savings_accounts
    resources :barangay_settings,  only: [:edit, :update],          module: :savings_accounts
    resources :voucher_confirmations, only: [:create],              module: :savings_accounts
  end

  resources :search_results, only: [:index, :show]

  resources :time_deposits, only: [:index, :show] do
    resources :transfers, only: [:new, :create],           module: :time_deposits
    resources :transfer_vouchers, only: [:show, :destroy], module: :time_deposits do
      resources :confirmations, only: [:create],           module: :transfer_vouchers
    end

    resources :withdrawal_vouchers, only: [:show, :destroy], module: :time_deposits do
      resources :confirmations, only: [:create],             module: :withdrawal_vouchers
    end

    resources :adjusting_entries, only: [:new, :create], module: :time_deposits
    resources :withdrawals, only: [:new, :create],       module: :time_deposits
    resources :term_extensions, only: [:new, :create],   module: :time_deposits
    resources :break_contracts, only: [:new, :create],   module: :time_deposits
    resources :settings, only: [:index],                 module: :time_deposits
    resources :beneficiaries, only: [:edit, :update],    module: :time_deposits
  end

  resources :employees, only: [:index, :show, :edit, :update] do
    resources :settings,             only: [:index],                        module: :employees
    resources :cash_accounts,        only: [:new, :create, :destroy],       module: :employees
    resources :store_fronts,         only: [:edit, :update],                module: [:employees, :settings]
    resources :info,                 only: [:index],                        module: :employees
    resources :blotters,             only: [:index],                        module: :employees
    resources :cash_disbursements,   only: [:index],                        module: [:employees, :reports]
    resources :cash_receipts,        only: [:index],                        module: [:employees, :reports]
    resources :memberships,          only: [:new, :create, :edit, :update], module: :employees
    resources :time_deposits,        only: [:index],                        module: :employees
    resources :savings_accounts,     only: [:index],                        module: :employees
    resources :share_capitals,       only: [:index],                        module: :employees
    resources :entries,              only: [:index, :show],                 module: :employees
    resources :remittances,          only: [:new, :create],                 module: :employees
    resources :cash_transfers,       only: [:new, :create],                 module: :employees
    resources :vault_fund_transfers, only: [:new, :create],                 module: :employees
    resources :reports,              only: [:index],                        module: :employees
    resources :vouchers,             only: [:index, :new, :create],         module: :employees
    resources :amounts,              only: [:new, :create, :destroy],       module: :employees
    resources :orders,               only: [:index],                        module: :employees
    resources :loans,                only: [:index],                        module: :employees
    resources :avatars,              only: [:update],                       module: :employees
    resources :accounts,            only: [:edit, :update],                 module: :employees
  end

  resources :loans, only: [:index, :show] do
    resources :payment_vouchers,     only: [:show],                  module: :loans do
      resources :confirmations,      only: [:create],                module: :payment_vouchers
    end
    resources :notes,                 only: [:index, :new, :create], module: :loans
    resources :barangays,             only: [:edit, :update],        module: :loans
    resources :settings,              only: [:index],                module: :loans
    resources :payments,              only: [:index, :new, :create], module: :loans

  end

  namespace :loans_module do
    resources :settings,     only: [:index]
    namespace :settings do
      resources :archives,           only: [:new, :create]
    end
  end

  resources :vouchers, only: [:index, :show, :destroy] do
    resources :disbursements, only: [:create],            module: :vouchers
    resources :loan_disbursements, only: [:new, :create], module: :vouchers
  end

  resources :bank_accounts, only: [:index, :show, :new, :create] do
    resources :vouchers, only: [:show, :destroy],            module: :bank_accounts
    resources :voucher_confirmations, only: [:create],       module: :bank_accounts
    resources :deposits, only: [:new, :create],              module: :bank_accounts
    resources :withdrawals, only: [:new, :create],           module: :bank_accounts
    resources :settings, only: [:index],                     module: :bank_accounts
  end

  resources :calendars, only: [:index, :show]

  resources :organizations, only: [:index, :show, :new, :create, :edit, :update] do
    resources :members, only: [:new, :create],   module: :organizations
    resources :loans, only: [:index],            module: :organizations
    resources :reports, only: [:index],          module: :organizations
    resources :share_capitals, only: [:index],   module: :organizations
    resources :settings, only: [:index],         module: :organizations
    resources :savings_accounts, only: [:index], module: :organizations

  end

  resources :membership_applications, only: [:new, :create]

  resources :cooperatives, only: [:show] do
    resources :barangays, only: [:new, :create], module: :cooperatives
    resources :logos, only: [:create],           module: :cooperatives
  end

  resources :monitoring, only: [:index]
  namespace :monitoring do
    resources :share_capitals, only: [:index]
    resources :savings_products, only: [:index]
    resources :loan_products, only: [:index]
    resources :store_fronts, only: [:index]
  end

  resources :filtered_loans, only: [:index], module: :loans_module
  resources :matured_loans, only: [:index],  module: :loans_module

  resources :barangays, only: [:index, :show, :new, :create, :edit, :update] do
    resources :loans, only: [:index],                  module: :barangays
    resources :savings, only: [:index],                module: :barangays
    resources :members, only: [:index, :new, :create], module: :barangays
  end

  resources :memberships, only: [:index, :show] do
    resources :share_capital_subscriptions, only: [:new, :create], module: :memberships
    resources :program_subscriptions, only: [:create],             module: :memberships do
      resources :payments, only: [:new, :create],                  module: :program_subscriptions
    end
  end

  namespace :cooperators do
    resources :accounts, only: [:show]
    resources :sign_ups, only: [:new]
  end

  resources :program_subscriptions, only: [:show] do
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
    resources :entries, only: [:index], module: :cooperative_services
    resources :balance_sheets,  only: [:index],        module: :cooperative_services
    resources :income_statements,  only: [:index],     module: :cooperative_services
    resources :settings,        only: [:index],        module: :cooperative_services
    resources :accounts,        only: [:new, :create], module: :cooperative_services do
      resources :activations,   only: [:create],       module: :accounts
      resources :deactivations, only: [:create],       module: :accounts
    end
  end

  namespace :coop_module do
    resources :search_results, only: [:index]
  end

  resources :time_deposit_applications, only: [:new, :create] do
    resources :vouchers, only: [:show, :destroy],      module: :time_deposit_applications
    resources :voucher_confirmations, only: [:create], module: :time_deposit_applications
  end

  resources :savings_account_applications, only: [:new, :create] do
    resources :vouchers, only: [:show, :destroy],      module: :savings_account_applications
    resources :voucher_confirmations, only: [:create], module: :savings_account_applications
  end

  resources :share_capital_applications, only: [:new, :create] do
    resources :vouchers, only: [:show, :destroy],      module: :share_capital_applications
    resources :voucher_disbursements, only: [:create], module: :share_capital_applications
  end

  resources :portfolios, only: [:index]

  namespace :portfolios do
    resources :savings,        only: [:index]
    resources :share_capitals, only: [:index]
    resources :time_deposits,  only: [:index]
    resources :loans,          only: [:index]
  end

  authenticated :member_account do
    root to: 'member_accounts#show'
  end

  unauthenticated :user do
    root :to => 'home#index', :constraints => lambda { |request| request.env['warden'].user.nil? }, as: :unauthenticated_root
  end
  unauthenticated :member_account do
    root :to => 'home#index', :constraints => lambda { |request| request.env['warden'].member_account.nil? }, as: :unauthenticated_member_root
  end
  resources :bank_account_applications, only: [:new, :create]
  mount ActionCable.server => '/cable'
  resources :leads, only: [:new, :create]
  namespace :portfolios do
    resources :loans, only: [:index]
  end
end
