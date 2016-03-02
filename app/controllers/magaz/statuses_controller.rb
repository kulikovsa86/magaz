# == Schema Information
#
# Table name: magaz_statuses
#
#  id         :integer          not null, primary key
#  code       :string
#  name       :string
#  note       :text
#  closed     :boolean          default(FALSE)
#  position   :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

require_dependency "magaz/application_controller"

module Magaz
  class StatusesController < ApplicationController
    before_action :set_status, only: [:edit, :update, :destroy, :up, :down]

    # GET    /statuses(.:format)
    def index
      @statuses = Status.order(:position)
    end

    # GET    /statuses/new(.:format)
    def new
      @status = Status.new
    end

    # POST   /statuses(.:format)
    def create
      @status = Status.new(status_params)
      if @status.save
        redirect_to edit_status_path(@status), notice: t('.success')
      else
        render :new
      end
    end

    # GET    /statuses/:id/edit(.:format)
    def edit
    end

    # PATCH/PUT  /statuses/:id(.:format)
    def update
      if @status.update(status_params)
        redirect_to edit_status_path(@status), notice: t('.success')
      else
        render :edit
      end
    end

    # PATCH  /statuses/:status_id/up(.:format)
    def up
      @status.move_higher
      redirect_to statuses_path
    end

    # PATCH  /statuses/:status_id/down(.:format)
    def down
      @status.move_lower
      redirect_to statuses_path
    end

    # DELETE /statuses/:id(.:format)
    def destroy
      @status.destroy
      redirect_to statuses_path, notice: t('.success')
    end

    private
      # Use callbacks to share common setup or constraints between actions.
      def set_status
        if params[:id]
          @status = Status.find(params[:id])
        else
          @status = Status.find(params[:status_id])
        end
      end

      def status_params
        params.require(:status).permit(:code, :name, :note, :closed)
      end

  end
end
