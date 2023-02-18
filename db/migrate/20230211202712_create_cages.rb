class CreateCages < ActiveRecord::Migration[7.0]
  def change
    create_table :cages do |t|
      t.string :number, null: false, unique: true
      t.belongs_to :diet,
                   null: true, foreign_key: true,
                   comment: 'Cages don\'t acquire a diet until the first dino is installed'
      t.belongs_to :species,
                   null: true, foreign_key: true,
                   comment: 'Cages that hold conivors can only contain the same species'
      t.timestamps
    end
  end
end
