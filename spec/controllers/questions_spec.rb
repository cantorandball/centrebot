require 'spec_helper'

Rspec.describe QuestionsController do
  describe "index" do
    it "returns answer fields when asked" do
      question = create(:question)
      responder = create(:responder)
      answer = create(:answer,
                      responder: responder,
                      question_text: question.text)
    end
  end
end