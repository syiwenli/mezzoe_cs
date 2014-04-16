class User < ActiveRecord::Base
  validates :email, presence: {message: I18n.t('activemodel.user.error.email.required')}
  #/\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\z/i
  #\A[\w\+\-\=\.]+@[a-z\d][\w\-]*\.[a-z]{2,}\z
  #/\A[\w\+\-\=\.]+@[a-z\d][\w\-]*(\.[a-z\d]\w*)*\.[a-z]{2,}\z/i,
  validates :email, format: { with: /\A[\w\+\-\=\.]+@[a-z\d][\w\-]*\.[a-z]{2,4}\z/i,
                              message: I18n.t('activemodel.user.error.email.format')}
  validates :email, uniqueness: {message: I18n.t('activemodel.user.error.email.unique')}

  def prepare_user(survey_param)
    #to ensure email is unique since psql is case insensitive
    self.email = self.email.try(:downcase)
    if User.exists?(email: self.email)
      false
    else
      self.survey = data_to_hash(survey_param)
      true
    end
  end

  def data_to_hash(survey)
    #input = "{2=> yes}{fin=> yes}"
    #output = "{2=> yes, fin => yes}"
    if survey.is_a? String
      data = survey.scan(/(\d|[a-z]*)=>\s([a-z]*)/)
      #[["2", "yes"], ["fin", "yes"]]
      if data.empty?
        survey_data = nil
      else
        survey_data = data.to_h
      end
    else
      survey_data = nil
    end
    survey_data
  end

end
