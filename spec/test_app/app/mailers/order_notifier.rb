class OrderNotifier < ApplicationMailer

  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.order_notifier.tested.subject
  #
  def tested
    @greeting = "Hi"

    mail to: "to@example.org"
  end
end
