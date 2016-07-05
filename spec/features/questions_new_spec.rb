require "rails_helper"
require "spec_helper"

describe "New question", type: :feature do
  before do
    visit "/questions/new"
  end

  it "has a title to tell you where you are" do
    expect(page).to have_text "Create a new question"
  end

  it "allows the user to select a question type" do
    expect(page).to have_css("#question_type_DateQuestion")
  end

  it "has a textarea to allow the user to enter the question text" do
    expect(page).to have_css("#question_text")
  end

  it "allows the user to submit the question" do
    expect(page).to have_button "Save Question"
  end

  it "shows an error if the form is incorrect" do
    fill_in("Question text", with: "Integer posuere erat a ante venenatis dapibus posuere velit aliquet. Nulla vitae elit libero, a pharetra augue. Donec sed odio dui. Curabitur blandit tempus porttitor. Maecenas sed diam eget risus varius blandit sit amet non magna. Cras justo odio, dapibus ac facilisis in, egestas eget quam. Donec sed odio dui.")
    click_on("Save Question")

    expect(page).to have_text "Text is too long"
  end

  it "shows a flash when successful" do
    fill_in("Question text", with: "What colour is the sky?")
    click_on("Save Question")

    expect(page).to have_text "Question created"
  end
end
