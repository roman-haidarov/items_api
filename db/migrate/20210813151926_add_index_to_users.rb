class AddIndexToUsers < ActiveRecord::Migration[6.1]
  def change
    add_index :users, :email, unique: true
    add_reference :items, :user, foreign_key: true
  end
end
