class AddMessageToOutcome < ActiveRecord::Migration
  def change
    change_table :outcomes do |t|
      t.string :message
    end
  end
end
