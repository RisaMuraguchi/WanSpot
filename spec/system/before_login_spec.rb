require 'rails_helper'

describe 'ユーザーログイン前のテスト' do

  describe 'トップ画面のテスト' do
    before do
      visit root_path
    end

    context '表示内容の確認' do
      it 'URLが正しい' do
        expect(current_path).to eq '/'
      end
      it "ロゴがトップページへのリンクである" do
        find(".navbar-brand").click
        expect(current_path).to eq "/"
      end
    end

    context "新規登録画面" do
      it "URLが正しい" do
        click_on "Sign up"
        expect(current_path).to eq "/users/sign_up"
      end
    end

    context "ログイン画面" do
      it "ユーザー側ログインURLが正しい" do
        click_on "Log in"
        expect(current_path).to eq "/users/sign_in"
      end
      it "管理者側ログインURLが正しい" do
        expect(new_admin_session_path).to eq "/admin/sign_in"
      end
    end

    context "ゲストログイン画面" do
      it "URLが正しい" do
        click_on "Guest"
        expect(current_path).to eq "/users/1"
      end
    end

    context "権限のないページへのアクセス" do
      it "ユーザーログイン前に新規投稿画面に遷移できない" do
        visit "/posts/new"
        expect(current_path).to eq "/users/sign_in"
      end
      it "管理者ログイン前に会員一覧に遷移できない" do
        visit "/admin/users"
        expect(current_path).to eq "/admin/sign_in"
      end
    end

  end
end


describe 'ユーザ新規登録のテスト' do
    before do
      visit new_user_registration_path
    end

    context '新規登録成功のテスト' do
      before do
        fill_in 'user[name]', with: Faker::Lorem.characters(number: 10)
        fill_in 'user[email]', with: Faker::Internet.email
        fill_in 'user[password]', with: 'password'
        fill_in 'user[password_confirmation]', with: 'password'
      end
      it '正しく新規登録される' do
        expect { click_button '新規登録' }.to change(User.all, :count).by(1)
      end
      it '新規登録後のリダイレクト先が、新規登録できたユーザの詳細画面になっている' do
        click_button '新規登録'
        expect(current_path).to eq '/users/' + User.last.id.to_s
      end
    end
end

describe 'ユーザログイン' do
    let(:user) { create(:user) }

    before do
      visit new_user_session_path
    end

    context 'ログイン成功のテスト' do
      before do
        fill_in 'user[email]', with: user.email
        fill_in 'user[password]', with: user.password
        click_button 'ログイン'
      end

      it 'ログイン後のリダイレクト先が、投稿一覧画面になっている' do
        expect(current_path).to eq '/posts'
      end
    end

    context 'ログイン失敗のテスト' do
      before do
        fill_in 'user[email]', with: ''
        fill_in 'user[password]', with: ''
        click_button 'ログイン'
      end

      it 'ログインに失敗し、ログイン画面にリダイレクトされる' do
        expect(current_path).to eq '/users/sign_in'
      end
    end

end

describe 'ユーザログアウトのテスト' do
    let(:user) { create(:user) }

    before do
      visit new_user_session_path
      fill_in 'user[email]', with: user.email
      fill_in 'user[password]', with: user.password
      click_button 'ログイン'
      logout_link = find_all('a')[4].native.inner_text
      logout_link = logout_link.gsub(/\n/, '').gsub(/\A\s*/, '').gsub(/\s*\Z/, '')
      click_link logout_link
    end

    context 'ログアウト機能のテスト' do
      it 'ログアウト後のリダイレクト先が、トップになっている' do
        expect(destroy_user_session_path).to eq '/users/sign_out'
      end
    end
end