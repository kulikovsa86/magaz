module Magaz
  class ApplicationController < ActionController::Base
    before_filter :set_locale
    before_action :set_demo_mode
    before_action :authenticate_user!

    private

      def notify(opt = {})
        ActiveSupport::Notifications.instrument('magaz.custom_event', options: opt)
      end

      def set_locale
        # if params[:locale] is nil then I18n.default_locale will be used
        I18n.locale = params[:locale]
      end

      def set_demo_mode
        @demo_mode = Magaz::Setting.get_bool('magaz-demo-mode')
      end

  end
end
