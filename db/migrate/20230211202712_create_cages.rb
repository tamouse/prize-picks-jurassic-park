class CreateCages < ActiveRecord::Migration[7.0]
  def change
    create_table :cages do |t|
      t.string :number, null: false, unique: true
      t.belongs_to :vore, null: false, foreign_key: true

      t.timestamps
    end
  end
end
