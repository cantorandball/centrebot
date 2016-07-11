class AddQuestionTextToAnswer < ActiveRecord::Migration
  def change
    add_column :answers, :question_text, :string, null: false
    remove_reference :answers, :question
  end
end
