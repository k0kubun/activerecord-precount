class ApplicationController < ActionController::Base
  def index
    @tweets = Tweet.all
  end
end
