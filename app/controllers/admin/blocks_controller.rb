class Admin::BlocksController < AdminController

  def create
    block_type = params[:block_type]
    @shop.add_block(block_type)
    redirect_to edit_admin_settings_path
  end

  def destroy
    blocks = @shop.blocks.dup
    blocks.reject! { |b| b['id'] == params[:id] }
    @shop.update(blocks_config: blocks)
    redirect_to edit_admin_settings_path
  end

  def reorder
    blocks = @shop.blocks.dup
    from = params[:from].to_i
    to = params[:to].to_i
    
    return head :bad_request if from < 0 || to < 0 || from >= blocks.length
    
    blocks.insert(to, blocks.delete_at(from))
    @shop.update(blocks_config: blocks)
    
    render json: { success: true }
  end

  def delete
    blocks = @shop.blocks.dup
    index = params[:index].to_i
    
    return head :bad_request if index < 0 || index >= blocks.length
    
    blocks.delete_at(index)
    @shop.update(blocks_config: blocks)
    
    render json: { success: true }
  end

end