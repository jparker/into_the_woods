# frozen_string_literal: true

class CreateReceivables < ActiveRecord::Migration[7.0]
  def change
    create_table :receivables do |t|
      t.references :billable, null: false, foreign_key: { on_delete: :restrict }
      t.references :receipt, null: false, foreign_key: { on_delete: :cascade }
      t.decimal :gross_rate, precision: 10, scale: 2, null: false
      t.decimal :commission_rate, precision: 10, scale: 2, null: false
      t.decimal :commission, precision: 10, scale: 2, null: false

      t.timestamps

      t.check_constraint 'commission_rate BETWEEN 0 AND 1',
                         name: 'receivables_commission_rate_chk'
    end
  end
end
