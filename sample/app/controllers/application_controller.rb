class ApplicationController < ActionController::Base
  def index
    @tweets = Tweet.all
    if eager_load?
      @tweets = @tweets.preload(:replies_count, in_reply_to: :favorites_count)
    end
  end

  def eager_load?
    params[:eager_load] == 'true'
  end
  helper_method :eager_load?
end
