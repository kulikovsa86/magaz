module Magaz
  class ApplicationController < ActionController::Base
    before_action :authenticate_user!

    private

      def notify(opt = {})
        ActiveSupport::Notifications.instrument('magaz.custom_event', options: opt)
      end
  end
end
