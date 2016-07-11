FactoryGirl.define do
  factory :responder do
    source "sms"
    identifier "07702667365"
  end

  factory :question do
    text "What's your favourite colour?"

    factory :multiple_choice_question, class: MultipleChoiceQuestion do
      type "MultipleChoiceQuestion"

      after(:create) do |question|
        create_list(:outcome, 3, question: question)
      end
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
    question_text "What?"

    responder
  end

  factory :outcome do
    value "3: Pidgeons"
    question
    next_question nil

    trait :next_question do
      next_question factory: :question
    end
  end
end
