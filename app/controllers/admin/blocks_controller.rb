class Admin::BlocksController < ApplicationController
  before_action :set_shop

  def create
    Block.create!(shop: @shop, block_type: params[:block_type], position: @shop.blocks.count + 1, content: {})
    redirect_to edit_admin_settings_path
  end

  def destroy
    Block.find(params[:id]).destroy
    redirect_to edit_admin_settings_path
  end

  def reorder
    Block.find(params[:id]).insert_at(params[:position].to_i)
    render json: { success: true }
  end

  def update
    Block.find(params[:id]).update(content: block_params[:content])
    head :ok
  end

  private

  def set_shop
    @shop = Shop.first
  end

  def block_params
    params.require(:block).permit(content: {})
  end
end
