# This sets up a basic set of question and answer flows to allow for testing.
# It should cover a few of the basic question types.

first_question = MultipleChoiceQuestion.create(
  text: "This is the first question. Do you like cheese?",
)

second_question = OpenTextQuestion.create(
  text: "Explain why or why you don't like camping.",
)

first_question.outcomes.create(value: "yes", next_question: second_question)
