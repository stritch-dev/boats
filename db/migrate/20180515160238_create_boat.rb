class CreateBoat < ActiveRecord::Migration[5.2]
  def change
    create_table :boats do |t|
      t.string :name
      t.string :size_description # such as single, double, quad, pair, four or eight
    end
  end
end
