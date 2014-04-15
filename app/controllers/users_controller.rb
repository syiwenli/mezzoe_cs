class UsersController < ApplicationController

  def index
    @init = Survey::Questions.start_question
    @user = User.new
  end

  def create
    begin
      @user = User.new(user_params)
      if @user.prepare_user(params["user"]["survey"])
        @user.save
        redirect_to root_path, notice: I18n.t('thanks')
      else
        redirect_to root_path, alert: I18n.t('activemodel.user.error.email.unique')
      end
    rescue => e
      #TODO: set up logger debug
      logger.debug "Exception: #{e.inspect} \n #{e.backtrace}"
      redirect_to root_path, alert: I18n.t('uh_oh')
    end

  end

  private
  def user_params
    params.require(:user).permit(:email)
  end

end