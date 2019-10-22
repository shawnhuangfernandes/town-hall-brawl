class CreateCitizens < ActiveRecord::Migration[5.0]
  def change
    create_table :citizens do |table_element|
      table_element.string :name
      table_element.integer :strength
      table_element.integer :health
    end
  end
end
