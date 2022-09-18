class CreateMerchants < ActiveRecord::Migration[5.2]
  def change
    create_table :merchants do |t|
      t.string :name, null: false
      t.string "status", default: "disabled"
      t.timestamps
    end
  end
end
