class AddDinosaurCountToCage < ActiveRecord::Migration[7.0]
  def change
    add_column :cages, :dinosaurs_count, :integer
  end
end
