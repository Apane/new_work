class QuestionsController < ApplicationController
  before_filter :authenticate_user!

  def update
    @question = Question.find params[:id]
    @question.update_attributes(params[:question])
    respond_with_bip @question
  end
end
