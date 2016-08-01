module QuestionsHelper
  def question_type_radio_group(question)
    question_types = Question::TYPES

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

  def linked_questions(question)
    linked_qs = []
    question.outcomes.each do |outcome|
      linked_qs.push(outcome.next_question.name) if outcome.next_question
    end
    linked_qs.uniq
  end
end
