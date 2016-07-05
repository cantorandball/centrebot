module QuestionsHelper
  def question_type_radio_group(question)
    question_types = Question::TYPES
    current_question_type = question.type

    question_types.each do |type|
      if question.type == type
        concat radio_button_tag("question[type]", type, true)
      else
        concat radio_button_tag("question[type]", type)
      end
      concat label_tag("question_type_" + type, type.titleize, class: "label-inline")
    end
  end

  def answer_contextual_title(context)
    if context == "create"
      return "New Answer"
    else
      return "Edit Answer"
    end
  end

  def contextual_outcome_dropdown(context, outcome=nil)
    if context == "create"
      return render "questions/new_outcome"
    else
      return render "questions/existing_outcome", outcome: outcome
    end
  end
end
