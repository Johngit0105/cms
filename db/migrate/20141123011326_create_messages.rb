class CreateMessages < ActiveRecord::Migration[5.0]
  def change
    create_table :messages do |table|
      table.belongs_to :site, null: false, foreign_key: { name: 'fk_messages_site_id' }, index: { name: 'fk__messages_site_id' }

      table.string :subject, null: false, limit: 64
      table.string :name, null: false, limit: 64
      table.string :email, null: false, limit: 64
      table.string :phone, limit: 32
      table.text :message, null: false

      table.timestamps
    end
  end
end
