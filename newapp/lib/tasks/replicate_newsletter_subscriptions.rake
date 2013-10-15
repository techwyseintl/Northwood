namespace :northwood do

  desc "Everybody that has signed up for the Rate Watch newsletter will also be signed up for Our News"
	task :replicate_newsletter_subscriptions  => [:environment] do |t|
    
    puts "Replicating newsletter subscriptions:"
    @ratewatch = Newsletter.find(1)
    @our_news = Newsletter.find(2)
    @ratewatch.subscriptions.each do |subscription|
      if !@our_news.subscriptions.find_by_contact_id(subscription.contact_id)
        puts "Subscribing.."
        Subscription.create(:contact_id=>subscription.contact_id, :newsletter_id=>@our_news.id)
      end
    end
  end       
end