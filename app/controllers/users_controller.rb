class UsersController < ApplicationController

  def index
    @init = Survey::Questions.start_question
    @user = User.new
  end

  def create
    begin
      @user = User.new(user_params)
      #to ensure email is unique since psql is case insensitive
      @user.email.downcase!
      @user.survey = @user.data_to_hash(params["user"]["survey"])
      unless @user.valid?
        redirect_to root_path, alert: I18n.t('activemodel.user.error.email.unique') and return
      end
      if @user.save
        redirect_to root_path, notice: I18n.t('thanks')
      else
        redirect_to root_path, alert: I18n.t('uh_oh')
      end
    rescue => e
      Rails.logger.debug "Exception: #{e.inspect} \n #{e.backtrace}"
    end
  end

  private
  def user_params
    params.require(:user).permit(:email)
  end

end