# frozen_string_literal: true

class CreateReceipts < ActiveRecord::Migration[7.0]
  def change
    create_table :receipts do |t|
      t.date :date, null: false
      t.string :reference_no, null: false

      t.timestamps

      t.index :date
      t.index :reference_no
    end
  end
end
