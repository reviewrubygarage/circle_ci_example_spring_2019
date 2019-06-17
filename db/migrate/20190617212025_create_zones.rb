class CreateZones < ActiveRecord::Migration[5.2]
  def change
    create_table :zones do |t|
      t.references :school
      t.string :name
    end
  end
end
