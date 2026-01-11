class CreateDevices < ActiveRecord::Migration[8.0]
  def change
    create_table :devices do |t|
      t.references :user, null: false, foreign_key: true
      t.string :jwt_token
      t.datetime :revoked_at

      t.timestamps
    end
  end
end
