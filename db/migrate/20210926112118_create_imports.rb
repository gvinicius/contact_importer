class CreateImports < ActiveRecord::Migration[6.1]
  def change
    create_table :imports do |t|
      t.integer :status, default: 0
      t.text :report

      t.timestamps
    end
  end
end
