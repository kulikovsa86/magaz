module Magaz
  class ApplicationController < ActionController::Base
    before_filter :set_locale
    before_action :authenticate_user!

    private

      def notify(opt = {})
        ActiveSupport::Notifications.instrument('magaz.custom_event', options: opt)
      end

      def set_locale
        # if params[:locale] is nil then I18n.default_locale will be used
        puts "************************************"
        puts params
        puts "************************************"
        I18n.locale = params[:locale]
      end
  end
end
