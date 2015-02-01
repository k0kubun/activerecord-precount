class ApplicationController < ActionController::Base
  AVAILABLE_LOADERS = %w[N+1 precount eager_count].freeze
  DEFAULT_LOADER    = 'N+1'

  def index
    @tweets = Tweet.all
    case loader
    when 'precount'
      @tweets = @tweets.precount(:replies).preload(in_reply_to: :favorites_count)
    when 'eager_count'
      @tweets = @tweets.eager_count(:replies).eager_load(in_reply_to: :favorites_count)
    end
  end

  def precount?
    loader == 'precount'
  end
  helper_method :precount?

  def eager_count?
    loader == 'eager_count'
  end
  helper_method :eager_count?

  def loader
    if AVAILABLE_LOADERS.include?(params[:loader])
      params[:loader]
    else
      DEFAULT_LOADER
    end
  end
  helper_method :loader
end
