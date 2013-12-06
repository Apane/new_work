module QuestionsHelper
  def answer_for(question)
    if question.answer.present?
      if question.answer.length > 0
        simple_format(question.answer)
      end
    else
      'I am empty...'
    end
  end
end
