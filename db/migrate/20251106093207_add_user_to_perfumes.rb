class AddUserToPerfumes < ActiveRecord::Migration[7.2]
  def change
    add_reference :perfumes, :user, null: false, foreign_key: true
  end
end
