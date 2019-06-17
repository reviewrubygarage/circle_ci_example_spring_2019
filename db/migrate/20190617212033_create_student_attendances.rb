class CreateStudentAttendances < ActiveRecord::Migration[5.2]
  def change
    create_table :student_attendances do |t|
      t.references :zone, foreign_key: true
      t.string :identifier
      t.datetime :first_seen_at
      t.datetime :last_seen_at
    end
  end
end
