class LandingsController < ApplicationController
  def index
    flash[:error] = "Invalid email or password"
  end
end
