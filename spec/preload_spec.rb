require "spec_helper"

describe "#preload" do
  let(:replies_count) { 3 }
  let!(:tweet) { FactoryGirl.create(:tweet) }
  before do
    replies_count.times do
      FactoryGirl.create(:reply, tweet: tweet)
    end
  end

  context "given a single association" do
    context "given has_many association" do
      it "works as usual" do
        tweet = Tweet.preload(:replies).first
        expect(tweet.replies.count).to eq(replies_count)
      end
    end

    context "given belongs_to association" do
      let!(:reply) { FactoryGirl.create(:reply, tweet: tweet) }

      it "works as usual" do
        preloaded_reply = Reply.preload(:tweet).find(reply.id)
        expect(preloaded_reply.tweet).to eq(tweet)
      end
    end

    context "given count_preloadable association" do
      it "does not execute N+1 queries" do
        expect_query_counts(0) {}
      end

      it "caches valid counts into records" do
        expect_query_counts(0) {}
      end
    end
  end
end
