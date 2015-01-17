##class TeamMembersController < ApplicationController
#  before_action :set_team_member, only: [:show, :edit, :update, :destroy]

#  respond_to :html

#  def new
#    @team_member = TeamMember.new
#    respond_with(@team_member)
#  end

#  def edit
#  end

#  def create
#    @team_member = TeamMember.new(team_member_params)
#   @team_member.save
#    respond_with(@team_member)
#  end

#  def update
#    @team_member.update(team_member_params)
#    respond_with(@team_member)
#  end

#  def destroy
#    @team_member.destroy
#    respond_with(@team_member)
#  end

##  private
#   def set_team_member
#      @team_member = TeamMember.find(params[:id])
#    end

##    def team_member_params
##      params.require(:team_member).permit(:submission_id, :user_id)
##    end
##end
