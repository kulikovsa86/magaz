require_dependency "magaz/application_controller"

module Magaz
  class SettingsController < ApplicationController
    def index
    end

    def update
      params.require(:magaz).permit(:advanced)
      Magaz::Setting.set_bool('magaz-advanced', params[:magaz][:advanced])
      Magaz::Setting.set_bool('magaz-show-colors', params[:magaz][:'show-colors'])
      redirect_to settings_path, notice: t('.success')
    end
  end
end
