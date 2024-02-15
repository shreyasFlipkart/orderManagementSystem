class CreateTransitions < ActiveRecord::Migration[7.1]
  def change
    create_table :transitions do |t|

      t.references :event, foreign_key: { to_table: :events }
      t.references :from_state, foreign_key: { to_table: :states }
      t.references :to_state, foreign_key: { to_table: :states }
    end
  end
end
