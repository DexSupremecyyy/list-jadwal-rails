class CreateProjects < ActiveRecord::Migration[8.1]
  def change
    create_table :projects do |t|
      t.string :tittle
      t.text :description
      t.date :deadline

      t.timestamps
    end
  end
end
