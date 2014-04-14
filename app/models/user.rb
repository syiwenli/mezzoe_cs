class User < ActiveRecord::Base
  validates :email, presence: {message: I18n.t('activemodel.user.error.email.required')}
  #/\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\z/i
  #\A[\w\+\-\=\.]+@[a-z\d][\w\-]*\.[a-z]{2,}\z
  #/\A[\w\+\-\=\.]+@[a-z\d][\w\-]*(\.[a-z\d]\w*)*\.[a-z]{2,}\z/i,
  validates :email, format: { with: /\A[\w\+\-\=\.]+@[a-z\d][\w\-]*\.[a-z]{2,}\z/i,
                              message: I18n.t('activemodel.user.error.email.format')}
  validates :email, uniqueness: true


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
