# frozen_string_literal: true

class CreateClients < ActiveRecord::Migration[7.0]
  def change
    create_table :clients do |t|
      t.string :name, null: false

      t.timestamps

      t.index :name, unique: true
      t.index :name, using: 'gin',
                     opclass: :gin_trgm_ops,
                     name: 'index_clients_on_name_using_gin'
    end
  end
end
