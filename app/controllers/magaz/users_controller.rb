# == Schema Information
#
# Table name: magaz_users
#
#  id                     :integer          not null, primary key
#  email                  :string           default(""), not null
#  encrypted_password     :string           default(""), not null
#  reset_password_token   :string
#  reset_password_sent_at :datetime
#  remember_created_at    :datetime
#  sign_in_count          :integer          default(0), not null
#  current_sign_in_at     :datetime
#  last_sign_in_at        :datetime
#  current_sign_in_ip     :string
#  last_sign_in_ip        :string
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#

require_dependency "magaz/application_controller"

module Magaz
  class UsersController < ApplicationController

    # GET    /profile(.:format)
    def edit
      @user = current_user
      @user.build_profile if @user.profile.nil?
    end

    # PATCH  /profile(.:format)
    def update
      @user = current_user
      if @user.update(user_params)
        redirect_to edit_profile_path, notice: t('.success')
      else
        render :edit
      end
    end

    # PATCH  /update_password(.:format) 
    def update_password
      @user = current_user
      if @user.update_with_password(password_params)
        sign_in @user, :bypass => true
        redirect_to edit_profile_path, notice: t('.success')
      else
        render :edit
      end
    end

    private

      def user_params
        params.require(:user).permit(:email, profile_attributes: [:id, :last_name, :first_name, :phone, :email])
      end

      def password_params
        params.require(:user).permit(:password, :password_confirmation, :current_password)
      end
  end
end
