require_dependency "magaz/application_controller"

module Magaz
  class SettingsController < ApplicationController
    def index
    end

    def update
      params.require(:magaz).permit(:moulded, :'show-images', :'show-colors')
      Magaz::Setting.set_bool('magaz-moulded', params[:magaz][:moulded])
      Magaz::Setting.set_bool('magaz-show-images', params[:magaz][:'show-images'])
      Magaz::Setting.set_bool('magaz-show-colors', params[:magaz][:'show-colors'])
      redirect_to settings_path, notice: t('.success')
    end
  end
end
