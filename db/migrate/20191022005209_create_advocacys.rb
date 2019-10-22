class CreateAdvocacys < ActiveRecord::Migration[5.0]
  def change
    create_table :advocacies do |table_element|
      table_element.integer :citizen_id
      table_element.integer :initiative_id
    end
  end
end
