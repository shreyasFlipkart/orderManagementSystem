class RenameOrderDateInOrders < ActiveRecord::Migration[7.1]
  def change
    rename_column :orders, :order_date, :created_at
  end
end
