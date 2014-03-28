module Survey
  class Questions
    def self.start_question
      init_size = I18n.t('survey.questions.start_question').size
      rand_init = rand(1..init_size)
      [rand_init, I18n.t("survey.questions.start_question.question_#{rand_init}")]
    end
  end
end