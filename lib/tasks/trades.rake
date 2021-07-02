namespace :trades do
  desc "Remove incomplete invitations"
  task clean: :environment do
    puts "Starting task"
    incomplete_trades = Trade.where(receiver_name: nil)
    if incomplete_trades.empty?
      puts "No incomplete invitations"
    else
      incomplete_trades.each { |t| puts "Removing trade for #{t.item }" }
      incomplete_trades.destroy_all
    end
    puts "Done!"
  end
end
