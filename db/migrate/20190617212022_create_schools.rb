class CreateSchools < ActiveRecord::Migration[5.2]
  def change
    create_table :schools do |t|
      t.string :name
      t.string :url_address
      t.string :username
      t.string :password
    end
  end
end
