class HackathonExtrasController < ApplicationController
  def participants
    #@hackathon = Hackathon.find_by_subdomain!(request.subdomain)
    @applications = Application.where(hackathon_id: current_hackathon, accepted: true).all
  end

  def rules
  end

  private
    def current_hackathon
      @current_hackathon ||= Hackathon.find_by_subdomain!(request.subdomain)
    end
end
