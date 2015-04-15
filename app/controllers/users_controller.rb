class UsersController < ApplicationController

  def show
    @user = User.find_by_id(params[:id])
    @applications = Application.where(user_id: @user, accepted: true).all
    @submissions = Submission.where(user_id: @user).all
  end
end
