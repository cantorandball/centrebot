FactoryGirl.define do
  factory :responder do
    source "sms"
    identifier "447702342164"
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

  factory :answer do
    text ""

    responder
    question
  end

  factory :outcome do
    value "yes"

    question
    next_question nil

    trait :next_question do
      next_question factory: :question
    end
  end
end
