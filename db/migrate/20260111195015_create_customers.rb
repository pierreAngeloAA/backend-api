class CreateCustomers < ActiveRecord::Migration[8.0]
  def change
    create_table :customers do |t|
      t.string :document
      t.string :full_name
      t.string :email
      t.string :phone

      t.timestamps
    end
    add_index :customers, :document, unique: true
  end
end
