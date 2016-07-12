class AddQuestionTextToAnswer < ActiveRecord::Migration
  def change
    add_column :answers, :question_text, :string
  end
end
