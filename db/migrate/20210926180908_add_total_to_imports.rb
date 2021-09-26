class AddTotalToImports < ActiveRecord::Migration[6.1]
  def change
    add_column :imports, :total, :integer, default: 0
  end
end
