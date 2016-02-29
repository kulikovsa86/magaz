
ActiveSupport::Notifications.subscribe('magaz.custom_event') do |name, start, finish, id, payload|
 
  # puts "A magaz.custom_event has been received with some more extra #{payload[:options]}"

  # OrderNotifier.tested.deliver_now

end
