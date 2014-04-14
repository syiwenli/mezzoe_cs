module UsersHelper

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