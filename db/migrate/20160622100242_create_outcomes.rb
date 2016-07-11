class CreateOutcomes < ActiveRecord::Migration
  def change
    create_table :outcomes do |t|
      t.string :value
      t.references :question, index: true, foreign_key: true
      t.integer :next_question_id, index: true, foreign_key: true, default: nil
      t.string :message
      t.timestamps null: false
    end
  end
end
