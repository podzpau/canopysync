class SetDefaultContentOnBlocks < ActiveRecord::Migration[8.0]
  def change
    change_column_default :blocks, :content, from: nil, to: {}
  end
end
