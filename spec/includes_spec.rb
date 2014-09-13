require "spec_helper"

describe "#includes" do
  describe "builtin associations" do
    let(:replies_count) { 3 }
    let!(:tweet) { FactoryGirl.create(:tweet) }
    before do
      replies_count.times do
        FactoryGirl.create(:reply, tweet: tweet)
      end
    end

    context "given has_many association" do
      it "works as usual" do
        tweet = Tweet.includes(:replies).first
        expect(tweet.replies.count).to eq(replies_count)
      end
    end

    context "given belongs_to association" do
      let!(:reply) { FactoryGirl.create(:reply, tweet: tweet) }

      it "works as usual" do
        included_reply = Reply.includes(:tweet).find(reply.id)
        expect(included_reply.tweet).to eq(tweet)
      end
    end
  end

  describe "has_count association" do
    let(:tweets_count) { 3 }
    let(:tweets) do
      tweets_count.times.map do
        FactoryGirl.create(:tweet)
      end
    end

    before do
      tweets.each_with_index do |tweet, index|
        index.times do
          FactoryGirl.create(:reply, tweet: tweet)
        end
      end
    end

    it "does not execute N+1 queries by preload" do
      expect_query_counts(1 + tweets_count) { Tweet.all.map(&:replies_count) }
      expect_query_counts(2) { Tweet.all.includes(:replies_count).map(&:replies_count) }
    end

    it "counts properly" do
      expected = Tweet.all.map { |t| t.replies.count }
      expect(Tweet.all.map(&:replies_count)).to eq(expected)
      expect(Tweet.all.includes(:replies_count).map(&:replies_count)).to eq(expected)
    end
  end
end
