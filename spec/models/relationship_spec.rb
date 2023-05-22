require 'rails_helper'

RSpec.describe Relationship, type: :model do
  before do
    @user = create(:user)
    @another_user = create(:user)
    @relationship = create(:relationship)
    @another_relationship = build(:relationship)
  end

  describe 'フォロー機能' do
    context 'フォロー関係を保存できる場合' do
      it "followed_idとfollower_idがあれば保存できる" do
        expect(@relationship).to be_valid
      end
      it "followed_idが同じでもfollower_idが違えばフォローできる" do
        relationship2 = FactoryBot.build(:relationship, follower_id: @another_relationship.follower_id, followed_id: @relationship.followed_id)
        expect(relationship2).to be_valid
      end
    end
  end


end