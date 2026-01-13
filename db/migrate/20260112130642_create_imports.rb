class CreateImports < ActiveRecord::Migration[8.0]
  def change
    create_table :imports do |t|
      t.integer :status
      t.string :file
      t.text :error_report

      t.timestamps
    end
  end
end
