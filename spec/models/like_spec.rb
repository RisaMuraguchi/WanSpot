require 'rails_helper'

RSpec.describe 'Likeモデルのテスト', type: :model do
  describe 'バリデーションのテスト' do
    subject { like.valid? }

    let!(:other_like) { create(:like) }
    let(:like) { build(:like) }

    context '1User 1Post 1いいね' do
      it 'あるUserが同じPostにいいね出来ないこと' do
        like.user = other_like.user
        like.post = other_like.post
        is_expected.to eq false
      end
    end
  end

  describe 'アソシエーションのテスト' do
    context 'Userモデルとの関係' do
      it 'N:1となっている' do
        expect(Like.reflect_on_association(:user).macro).to eq :belongs_to
      end
    end

    context 'Postモデルとの関係' do
      it 'N:1となっている' do
        expect(Like.reflect_on_association(:post).macro).to eq :belongs_to
      end
    end
  end
end