class CreateDinosaurs < ActiveRecord::Migration[7.0]
  def change
    create_table :dinosaurs do |t|
      t.string :name, null: false, unique: true
      t.boolean :alive, default: true, null: false
      t.belongs_to :vore, null: false, foreign_key: true
      t.belongs_to :species, null: false, foreign_key: true
      t.belongs_to :cage, null: true, foreign_key: true, comment: "Dinosaurs aren't required to be in a cage on 'birth'"
      t.timestamps
    end
  end
end
