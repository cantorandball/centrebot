class QuestionsController < ApplicationController
  def index
    non_archived_questions = Question.all.where(archived: false)
    @questions = non_archived_questions.sort_by(&:name)
    @responders = Answer.all
    @answers = Answer.all

    respond_to do |format|
      format.html
      format.csv do
        send_data print_csv
      end
    end
  end

  def new
    @question = Question.new
    @question.outcomes.build
  end

  def edit
    @question = Question.find(params[:id])
    output_questions = []
    Question.all.each do |question|
      if question != @question && !question.archived
        output_questions.append question
      end
    end
    @other_questions = output_questions.sort_by(&:describe)
  end

  def create
    @question = Question.new question_params

    if @question.save
      flash[:notice] = "Question created"
      redirect_to questions_path
    else
      if @question.errors.any?
        @question.errors.full_messages.each do |error|
          flash[:error] = error
        end
      end
      render "new"
    end
  end

  def update
    @question = Question.find(params[:id])

    @other_questions = []
    Question.all.each do |question|
      if question != @question && !question.archived
        @other_questions.append question
      end
    end

    if @question.update(question_params)
      flash[:notice] = "Question updated"
      redirect_to edit_question_path(@question)
    else
      if @question.errors.any?
        @question.errors.full_messages.each do |error|
          flash[:error] = error
        end
      end
      render "edit"
    end
  end

  def archive
    @question = Question.find(params[:question_id])

    if @question.update_attribute(:archived, true)
      flash[:notice] = "Question archived"
      redirect_to questions_path
    else
      if @question.errors.any?
        @question.errors.full_messages.each do |error|
          flash[:error] = error
        end
      end
      render "index"
    end
  end

  private

  def question_params
    params.require(:question).permit(:text,
                                     :type,
                                     :tag,
                                     outcomes_attributes: [:id, :value,
                                                           :message,
                                                           :next_question_id,
                                                           :lower_bound,
                                                           :upper_bound,
                                                           :_destroy])
  end

  def csv_fields
    answers = []
    Answer.all.each do |answer|
      answer_hash = Hash.new
      answer_hash["Number"] = answer.responder.identifier
      answer_hash["Date sent"] = answer.created_at
      answer_hash["Question"] = answer.question_text
      answer_hash["Answer"] = answer.text
      answers.push(answer_hash)
    end
    answers
  end

  def print_csv
    attributes = csv_fields[0].keys

    CSV.generate(headers: true) do |csv|
      csv << attributes
      csv_fields.each do |line|
        csv << line.values
      end
    end
  end
end
