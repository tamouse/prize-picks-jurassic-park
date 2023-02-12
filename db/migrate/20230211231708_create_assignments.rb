# frozen_string_literal: true

# The linkage between dinosaurs and cages
class CreateAssignments < ActiveRecord::Migration[7.0]
  def change
    create_table :assignments do |t|
      t.references :dinosaur, null: false, foreign_key: true
      t.references :cage, null: false, foreign_key: true

      t.timestamps
    end
  end
end
