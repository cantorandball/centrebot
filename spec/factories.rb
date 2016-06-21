FactoryGirl.define do
  factory :responder do
  end

  factory :question do
    text "What's your favourite colour?"

    factory :multiple_choice_question, class: MultipleChoiceQuestion do
      type "MultipleChoiceQuestion"
    end

    factory :open_text_question, class: OpenTextQuestion do
      type "OpenTextQuestion"
    end

    factory :date_question, class: DateQuestion do
      type "DateQuestion"
    end

    factory :phone_question, class: PhoneQuestion do
      type "PhoneQuestion"
    end

    factory :email_question, class: EmailQuestion do
      type "EmailQuestion"
    end
  end
end
