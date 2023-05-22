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
        visit new_post_path
        attach_file('post[image]', Rails.root.join('spec/images/dogs.jpg'), visible: false)
        fill_in 'post[address]', with: Faker::Lorem.characters(number: 30)
        fill_in 'post[latitude]', with: 35.6761919
        fill_in 'post[longitude]', with: 139.6503106
        fill_in 'post[caption]', with: Faker::Lorem.characters(number: 100)
    end

    context '投稿のテスト' do
      it '自分の新しい投稿が正しく保存される' do
        expect { click_button 'Create Post' }.to change(user.posts, :count).by(1)
      end
      it 'リダイレクト先が、保存できた投稿の詳細画面になっている' do
        click_button 'Create Post'
        expect(current_path).to eq '/posts/' + Post.last.id.to_s
      end
    end
  end

  describe '自分の投稿詳細画面のテスト' do
    before do
      visit post_path(post)
    end

    context '表示内容の確認' do
      it 'URLが正しい' do
        expect(current_path).to eq '/posts/' + post.id.to_s
      end
      it 'ユーザー名のリンクが正しい' do
        expect(page).to have_link post.user.name, href: user_path(post.user)
      end
      it '投稿のcaptionが表示される' do
        expect(page).to have_content post.caption
      end
      it '投稿の画像が表示される' do
        expect(page).to have_selector("img[src*='.jpg']")
      end
      it '投稿の編集リンクが表示される' do
        expect(page).to have_link '編集', href: edit_post_path(post)
      end
      it '投稿の削除リンクが表示される' do
        expect(page).to have_link '削除', href: post_path(post)
      end
      it '投稿した日付が表示される' do
        expect(page).to have_content post.created_at.strftime('%Y/%m/%d')
      end
    end

    context '削除リンクのテスト' do
      it 'application.html.erbにjavascript_pack_tagを含んでいる' do
        is_exist = 0
        open("app/views/layouts/application.html.erb").each do |line|
          strip_line = line.chomp.gsub(" ", "")
          if strip_line.include?("<%=javascript_pack_tag'application','data-turbolinks-track':'reload'%>")
            is_exist = 1
            break
          end
        end
        expect(is_exist).to eq(1)
      end
      before do
        click_link '削除'
      end
      it '正しく削除される' do
        expect(Post.where(id: post.id).count).to eq 0
      end
      it 'リダイレクト先が、投稿一覧画面になっている' do
        expect(current_path).to eq '/posts'
      end
    end
  end

  describe '自分の投稿編集画面のテスト' do
    before do
      visit edit_post_path(post)
    end

    context '表示の確認' do
      it 'URLが正しい' do
        expect(current_path).to eq '/posts/' + post.id.to_s + '/edit'
      end
    end

    context '編集成功のテスト' do
      before do
        @post_old_caption = post.caption
        @post_old_image = post.image
        attach_file('post[image]', Rails.root.join('spec/images/profile_image.jpg'), visible: false)
        fill_in 'post[caption]', with: Faker::Lorem.characters(number: 100)
        click_button 'Update Post'
      end
      # it '画像が正しく更新される' do
      #   expect(post.reload.image).not_to eq @post_old_image
      # end
      it 'captionが正しく更新される' do
        expect(post.reload.caption).not_to eq @post_old_caption
      end
      it 'リダイレクト先が、更新した投稿の詳細画面になっている' do
        expect(current_path).to eq '/posts/' + post.id.to_s
      end
    end
  end

  describe 'マイページのテスト' do
    before do
      visit user_path(user)
    end

    context '表示の確認' do
      it 'URLが正しい' do
        expect(current_path).to eq '/users/' + user.id.to_s
      end
      it '投稿一覧のユーザ画像のリンク先が正しい' do
        expect(page).to have_link '', href: user_path(user)
      end
      it '投稿一覧に自分の投稿が表示され、リンクが正しい' do
        expect(page).to have_link post.caption, href: post_path(post)
      end
      it '他人の投稿は表示されない' do
        expect(page).not_to have_link '', href: user_path(other_user)
        expect(page).not_to have_content other_post.caption
      end
      it '自分の名前と紹介文が表示される' do
        expect(page).to have_content user.name
        expect(page).to have_content user.profile
      end
      it '自分のユーザ編集画面へのリンクが存在する' do
        click_link 'Edit Profile'
        expect(current_path).to eq '/users/' + user.id.to_s + '/edit'
      end
      it '自分のユーザ編集画面へのリンクが存在する' do
        click_link 'いいねした投稿'
        expect(current_path).to eq '/users/' + user.id.to_s + '/likes'
      end
    end
  end

  describe 'マイページ編集画面のテスト' do
    before do
      visit edit_user_path(user)
    end

    context '更新成功のテスト' do
      before do
        @user_old_name = user.name
        @user_old_profile = user.profile
        fill_in 'user[name]', with: Faker::Lorem.characters(number: 10)
        fill_in 'user[profile]', with: Faker::Lorem.characters(number: 20)
        expect(user.profile_image).to be_attached
        click_button '変更を保存'
        save_page
      end
      it 'nameが正しく更新される' do
        expect(user.reload.name).not_to eq @user_old_name
      end
      it 'profileが正しく更新される' do
        expect(user.reload.profile).not_to eq @user_old_profile
      end
      it 'リダイレクト先が、マイページになっている' do
        expect(current_path).to eq '/users/' + user.id.to_s
      end
    end
  end


end