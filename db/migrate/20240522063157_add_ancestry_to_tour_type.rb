class AddAncestryToTourType < ActiveRecord::Migration[7.0]
  def change
    add_column :tour_types, :ancestry, :string
    add_index :tour_types, :ancestry
  end
end
