class AddDeviseLockableToUsers < ActiveRecord::Migration[5.0]
  def change
    change_table :users do |table|
      table.integer :failed_attempts, default: 0, null: false
      table.string :unlock_token, index: :unique
      table.datetime :locked_at
    end
  end
end
