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
    questions_and_outcomes = []
    question.outcomes.each do |outcome|
      outcome_hash = { label: outcome.value }
      if outcome.next_question
        outcome_hash[:next_q] = outcome.next_question.name
      else
        outcome_hash[:next_q] = "Conclusion"
      end
      questions_and_outcomes.push(outcome_hash)
    end
    questions_and_outcomes
  end
end
