# == Schema Information
#
# Table name: magaz_settings
#
#  id         :integer          not null, primary key
#  name       :string
#  value      :string
#  param      :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

require_dependency "magaz/application_controller"

module Magaz
  class SettingsController < ApplicationController

    # GET    /settings(.:format)
    def index
    end

    # POST   /settings(.:format)
    def update
      Magaz::Setting.set('magaz-title', settings_params['title'])
      Magaz::Setting.set('magaz-notification-email', settings_params['notification-email'])
      Magaz::Setting.set_bool('magaz-cat-off', settings_params['cat-off'])
      # ---
      Magaz::Setting.set('magaz-full-name', settings_params['full-name'])
      Magaz::Setting.set('magaz-post-code', settings_params['post-code'])
      Magaz::Setting.set('magaz-city', settings_params['city'])
      Magaz::Setting.set('magaz-street', settings_params['street'])
      Magaz::Setting.set('magaz-main-phone', settings_params['main-phone'])
      Magaz::Setting.set('magaz-phones', settings_params['phones'])
      Magaz::Setting.set('magaz-fax', settings_params['fax'])
      Magaz::Setting.set('magaz-email', settings_params['email'])
      # ---
      Magaz::Setting.set('magaz-bank-name', settings_params['bank-name'])
      Magaz::Setting.set('magaz-inn', settings_params['inn'])
      Magaz::Setting.set('magaz-kpp', settings_params['kpp'])
      Magaz::Setting.set('magaz-bik', settings_params['bik'])
      Magaz::Setting.set('magaz-corr-account', settings_params['corr-account'])
      Magaz::Setting.set('magaz-abon-account', settings_params['abon-account'])
      Magaz::Setting.set('magaz-recipient', settings_params['recipient'])
      # ---
      Magaz::Setting.set('magaz-supplier', settings_params['supplier'])
      Magaz::Setting.set('magaz-shipper', settings_params['shipper'])
      # ---
      Magaz::Setting.set('magaz-director', settings_params['director'])
      Magaz::Setting.set('magaz-accountant', settings_params['accountant'])
      Magaz::Setting.set('magaz-responsible', settings_params['responsible'])
      # ---
      Magaz::Setting.set_bool('magaz-moulded', settings_params['moulded'])
      Magaz::Setting.set_bool('magaz-show-images', settings_params['show-images'])
      Magaz::Setting.set_bool('magaz-show-colors', settings_params['show-colors'])
      # ---
      redirect_to settings_path, notice: t('.success')
    end

    private

      def settings_params
        params.require(:magaz).permit(:title, :'notification-email', :'cat-off',
          :'full-name', :'post-code', :city, :street, :'main-phone', :phones, :fax, :email,
          :'bank-name', :inn, :kpp, :bik, :'corr-account', :'abon-account', :recipient,
          :supplier, :shipper,
          :director, :accountant, :responsible,
          :moulded, :'show-images', :'show-colors')
      end

  end
end
