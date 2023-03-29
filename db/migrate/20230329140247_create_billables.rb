# frozen_string_literal: true

class CreateBillables < ActiveRecord::Migration[7.0]
  def change
    create_table :billables do |t|
      t.references :booking, null: false, foreign_key: { on_delete: :cascade }
      t.decimal :gross_rate, precision: 10, scale: 2, default: 0, null: false
      t.decimal :collected, precision: 10, scale: 2, default: 0, null: false
      t.decimal :commission_rate, precision: 5, scale: 4, default: 0.1, null: false
      t.decimal :commission, precision: 10, scale: 2, default: 0, null: false

      t.timestamps

      t.check_constraint 'commission_rate BETWEEN 0 AND 1',
                         name: 'billables_commission_rate_chk'
    end
  end
end
