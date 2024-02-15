class CreateOrders < ActiveRecord::Migration[7.1]
  def change
    create_table :orders do |t|
      t.integer :cur_state_id
      t.datetime :order_timestamp
      t.timestamps
    end
  end
end
