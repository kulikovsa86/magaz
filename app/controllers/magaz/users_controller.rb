require_dependency "magaz/application_controller"

module Magaz
  class UsersController < ApplicationController
    def edit
      @user = current_user
    end

    def update
      redirect_to edit_profile_path
    end
  end
end
