# frozen_string_literal: true

class CreateBookings < ActiveRecord::Migration[7.0]
  def change
    create_table :bookings do |t|
      t.references :client, null: false, foreign_key: { on_delete: :restrict }
      t.references :vendor, null: false, foreign_key: { on_delete: :restrict }
      t.date :date, null: false

      t.timestamps

      t.index :date
    end
  end
end
