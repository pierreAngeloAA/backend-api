# Token revocation lives in `devices.revoked_at`; this table was never used.
class DropRevokedTokens < ActiveRecord::Migration[8.1]
  def change
    drop_table :revoked_tokens do |t|
      t.string :token
      t.timestamps
      t.index :token
    end
  end
end
