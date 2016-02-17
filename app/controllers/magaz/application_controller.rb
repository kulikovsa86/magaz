module Magaz
  class ApplicationController < ActionController::Base
    before_action :authenticate_user!

    # helper_method :notify

    private

      def notify(opt = {})
        ActiveSupport::Notifications.instrument('magaz.custom_event', options: opt)
      end
  end
end
