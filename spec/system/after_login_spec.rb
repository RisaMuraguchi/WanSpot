require 'rails_helper'

describe 'ユーザログイン後のテスト' do
  let(:user) { create(:user) }
  let!(:other_user) { create(:user) }
  let!(:post) { create(:post, user: user) }
  let!(:other_post) { create(:post, user: other_user) }

  before do
    visit new_user_session_path
    fill_in 'user[email]', with: user.email
    fill_in 'user[password]', with: user.password
    click_button 'ログイン'
  end

  describe 'ヘッダのテスト: ログインしている場合' do

    context 'マイページ' do
      it "URLが正しい" do
        click_on "My page"
        expect(current_path).to eq '/users/' + user.id.to_s
      end
    end

    context '新規投稿' do
      it "URLが正しい" do
        click_on "New"
        expect(current_path).to eq '/posts/new'
      end
    end

    context '投稿一覧' do
      it "URLが正しい" do
        click_on "List"
        expect(current_path).to eq '/posts'
      end
    end

    context 'マップ一覧' do
      it "URLが正しい" do
        click_on "Map"
        expect(current_path).to eq '/post/map'
      end
    end
  end

  describe '投稿一覧画面のテスト' do
    before do
      visit posts_path
    end

    context '表示内容の確認' do
      it 'URLが正しい' do
        expect(current_path).to eq '/posts'
      end
      it '投稿の画像のリンク先が正しい' do
        expect(page).to have_link '', href: post_path(post.user)
      end
      it '自分の投稿と他人の投稿のキャプションが表示される' do
        expect(page).to have_content post.caption
        expect(page).to have_content other_post.caption
      end
      it '自分の投稿と他人の投稿の名前が表示される' do
        expect(page).to have_content post.user.name
        expect(page).to have_content other_post.user.name
      end
    end
  end

  describe '新規投稿画面のテスト' do
    before do
        # fill_in 'post[image]', with: "#{Rails.root}/spec/images/dogs.jpg"
        fill_in 'post[address]', with: Faker::Lorem.characters(number: 30)
        fill_in 'post[latitude]', with: 35.6761919
        fill_in 'post[longitude]', with: 139.6503106
        fill_in 'post[caption]', with: Faker::Lorem.characters(number: 100)
    end

    it '自分の新しい投稿が正しく保存される' do
      expect { click_button 'Create Book' }.to change(user.posts, :count).by(1)
    end


  end


end