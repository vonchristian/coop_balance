namespace :account_running_balances do
  desc "Set posted_at on account_running_balances using entry_date and entry_time"
  task backfill_posted_at: :environment do
    puts "🔄 Backfilling posted_at..."

    total_updated = 0

    AccountingModule::RunningBalances::Account.where(posted_at: nil).find_in_batches(batch_size: 500) do |batch|
      batch.each do |arb|
        next unless arb.entry_date


       entry_datetime =  if arb.entry_time
          Time.zone.parse("#{arb.entry_date} #{arb.entry_time.strftime('%H:%M:%S')}")
       else
          arb.entry_date.to_time.beginning_of_day
       end

      arb.update_columns(posted_at: entry_datetime)
        total_updated += 1
      end
    end

    puts "✅ Done. Updated #{total_updated} account_running_balances with posted_at."
  end
end
