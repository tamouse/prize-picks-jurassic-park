class CreateCages < ActiveRecord::Migration[7.0]
  def change
    create_table :cages do |t|
      t.string :number, null: false, unique: true
      t.belongs_to :vore,
                   null: true, foreign_key: true,
                   comment: "Cages don't acquire a vore until the first dino is installed"

      t.timestamps
    end
  end
end
