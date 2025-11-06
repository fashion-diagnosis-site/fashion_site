class TweetsController < ApplicationController
    before_action :authenticate_user!, only: [:new, :create]
    def index
        @tweets = Tweet.all
    end
    def new
        @tweet = Tweet.new
    end
    def create
        @tweet = current_user.tweets.build(tweet_params)
        
        if @tweet.save
          redirect_to tweets_path, notice: '投稿しました'
        else
          flash.now[:alert] = '投稿に失敗しました'
          render :new, status: :unprocessable_entity
        end
    end

  private
  def tweet_params
    params.require(:tweet).permit(:title, :about)
  end
end