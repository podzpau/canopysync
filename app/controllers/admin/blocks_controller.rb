class Admin::BlocksController < AdminController
  before_action :load_shop
  
  def create
    Rails.logger.info "=== CREATE BLOCK CALLED ==="
    Rails.logger.info "Block type: #{params[:block_type]}"
    
    block_type = params[:block_type]
    default_config = BlockTypes::AVAILABLE_BLOCKS[block_type][:fields].index_with { '' }
    @shop.add_block(block_type, default_config)
    
    redirect_to edit_admin_settings_path, notice: 'Block added'
  end
  
  def edit
    @block_index = @shop.blocks.index { |b| b['id'] == params[:id] }
    @block = @shop.blocks[@block_index]
    render layout: false
  end
  
  def update
    block_index = @shop.blocks.index { |b| b['id'] == params[:id] }
    @shop.blocks[block_index]['config'] = block_params
    @shop.save
    head :ok
  end
  
  def destroy
    @shop.blocks.reject! { |b| b['id'] == params[:id] }
    @shop.save
    head :ok
  end
  
  def reorder
    order = params[:order]
    reordered_blocks = order.map { |id| @shop.blocks.find { |b| b['id'] == id } }
    @shop.blocks = reordered_blocks
    @shop.save
    head :ok
  end
  
  def preview
    render partial: 'admin/preview', layout: false
  end
  
  private
  
  def load_shop
    @shop = Shop.first
  end
  
  def block_params
    params.require(:config).permit!
  end
end