module QuestionsHelper
  def question_type_radio_group
    question_types = Question::TYPES

    question_types.each do |type|
      concat radio_button_tag("question[type]", type)
      concat label_tag("question_type_" + type, type.titleize, class: "label-inline")
    end
  end
end
