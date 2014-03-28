class UsersController < ApplicationController

  def index
    @init = Survey::Questions.start_question
  end

  def create
    @user = User.new(user_params)
    if @user.save
      redirect_to root_path, notice: 'Thanks for joining the waitlist!'
    else
      redirect_to root_path, notice: 'Uh oh...'
    end
  end

  private
  def event_params
    params.require(:user).permit(:email, :survey)
  end

end