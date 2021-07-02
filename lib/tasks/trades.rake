namespace :trades do
  desc "Remove incomplete invitations"
  task clean: :environment do
    puts "Starting task"
    incomplete_trades = Trade.where(receiver_name: nil)
    incomplete_trades.each { |t| puts "Removing trade for #{t.item }" }
    incomplete_trades.destroy_all
    puts "Done!"
  end
end
