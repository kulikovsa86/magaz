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
      params.require(:magaz).permit(:moulded, :'show-images', :'show-colors')
      Magaz::Setting.set_bool('magaz-moulded', params[:magaz][:moulded])
      Magaz::Setting.set_bool('magaz-show-images', params[:magaz][:'show-images'])
      Magaz::Setting.set_bool('magaz-show-colors', params[:magaz][:'show-colors'])
      redirect_to settings_path, notice: t('.success')
    end
  end
end
