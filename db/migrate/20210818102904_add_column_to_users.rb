class AddColumnToUsers < ActiveRecord::Migration[6.1]
  def change
    add_column :users, :born_years, :integer
  end
end
