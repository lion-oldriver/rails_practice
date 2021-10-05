require 'rails_helper'

describe 'ユーザログイン後のテスト' do
  let(:user) { create(:user) }
  let!(:other_user) {create(:user) }
  let!(:blog) {create(:blog, user: user) }
  let!(:other_blog) {create(:blog, user: other_user) }

  before do
    visit new_user_session_path
    fill_in 'user[name]', with: user.name
    fill_in 'user[password]', with: user.password
    click_button 'Log in'
  end

  describe 'ヘッダーテスト ログイン後' do
    context 'リンクの内容を確認' do
      subject { current_path }

      it 'Homeを押すとブログ一覧に遷移する' do
        home_link = find_all('a')[0].native.inner_text
        click_link home_link
        is_expected.to eq '/blogs'
      end
      it 'Aboutを押すとアバウトに遷移する' do
        about_link = find_all('a')[1].native.inner_text
        click_link about_link
        is_expected.to eq '/about'
      end
      it 'Newを押すと新規投稿ページに遷移する' do
        new_link = find_all('a')[2].native.inner_text
        click_link new_link
        is_expected.to eq '/blogs/new'
      end
    end
  end

  describe 'ブログ一覧画面のテスト' do
    before do
      visit blogs_path
    end

    context '表示内容の確認' do
      it 'urlが正しいか' do
        expect(current_path).to eq '/blogs'
      end
      it '自分と他人の投稿のタイトルのリンク先が正しいか' do
        expect(page).to have_link blog.title, href: blog_path(blog)
        expect(page).to have_link other_blog.title, href: blog_path(other_blog)
      end
      it '自分の他人の名前のリンク先が正しいか' do
        expect(page).to have_link user.name, href: user_path(user)
        expect(page).to have_link other_user.name, href: user_path(other_user)
      end
    end
  end

  describe 'ブログ詳細画面のテスト' do
    before do
      visit blog_path(blog)
    end

    context '表示内容の確認' do
      it 'urlが正しいか' do
        expect(current_path).to eq '/blogs/' + blog.id.to_s
      end
      it 'タイトルが表示されてるか' do
        expect(page).to have_content blog.title
      end
      it '本文が表示されているか' do
        expect(page).to have_content blog.body
      end
      it '編集のリンクがあるか' do
        expect(page).to have_link '編集', href: edit_blog_path(blog)
      end
      it '削除のリンクがあるか' do
        expect(page).to have_link '削除', href: blog_path(blog)
      end
      it 'Backのリンクがあるか' do
        expect(page).to have_link 'Back', href: blogs_path
      end
      it 'コメントフォームが表示されるか' do
        expect(page).to have_field 'blog_comment[comment]'
      end
      it 'コメントフォームが空である' do
        expect(find_field('blog_comment[comment]').text).to be_blank
      end
      it '投稿ボタンが存在する' do
        expect(page).to have_button '投稿'
      end
    end

    context '編集リンクのテスト' do
      it '編集画面に遷移する' do
        click_link '編集'
        expect(current_path).to eq '/blogs/' + blog.id.to_s + '/edit'
      end
    end

    context '削除リンクのテスト' do
      before do
        click_link '削除'
      end

      it '正しく削除されるか' do
        expect(Blog.where(id: blog.id).count).to eq 0
      end
      it 'リダイレクト先がブログ一覧画面になってる' do
        expect(current_path).to eq '/blogs'
      end
    end
  end

  describe 'ブログ新規作成画面のテスト' do
    before do
      visit new_blog_path
    end

    context '表示内容のテスト' do
      it '新規投稿の文字があるか' do
        expect(page).to have_content '新規投稿'
      end
      it '画像(複数)投稿フォームがあるか' do
        expect(page).to have_field 'blog[blog_files_images][]'
      end
      it 'titleフォームがあるか' do
        expect(page).to have_field 'blog[title]'
      end
      it 'titleフォームが値が入っていないか' do
        expect(find_field('blog[title]').text).to be_blank
      end
      it 'bodyフォームがあるか' do
        expect(page).to have_field 'blog[body]'
      end
      it 'bodyフォームに値が入っていないか' do
        expect(find_field('blog[body]').text).to be_blank
      end
      it 'categoryフォームがあるか' do
        expect(page).to have_field 'blog[category]'
      end
      it 'categoryフォームに値が入っていないか' do
        expect(find_field('blog[category]').text).to be_blank
      end
      it '投稿ボタンが表示されているか' do
        expect(page).to have_button '投稿'
      end
    end

    context '投稿成功のテスト' do
      before do
        fill_in 'blog[title]', with: Faker::Lorem.characters(number: 7)
        fill_in 'blog[body]', with: Faker::Lorem.characters(number: 20)
        fill_in 'blog[category]', with: Faker::Lorem.characters(number: 5)
      end

      it '自分の投稿が正しく保存される' do
        expect { click_button '投稿' }.to change(user.blogs, :count).by(1)
      end
    end
  end

  describe '編集画面のテスト' do
    before do
      visit edit_blog_path(blog)
    end

    context '表示のテスト' do
      it 'urlが正しい' do
        expect(current_path).to eq '/blogs/' + blog.id.to_s + '/edit'
      end
      it '編集画面の文字が表示されているか' do
        expect(page).to have_content '編集画面'
      end
      it '画像編集フォームが表示されているか' do
        expect(page).to have_field 'blog[image]'
      end
      it 'title編集フォームが表示されているか' do
        expect(page).to have_field 'blog[title]', with: blog.title
      end
      it 'body編集フォームが表示されているか' do
        expect(page).to have_field 'blog[body]', with: blog.body
      end
      it 'categoryフォームが表示されているか' do
        expect(page).to have_field 'blog[category]', with: blog.category
      end
      it '変更を保存ボタンが表示されているか' do
        expect(page).to have_button '変更を保存'
      end
    end

    context '編集成功のテスト' do
      before do
        @blog_old_title = blog.title
        @blog_old_body = blog.body
        @blog_old_category = blog.category
        fill_in 'blog[title]', with: Faker::Lorem.characters(number: 6)
        fill_in 'blog[body]', with: Faker::Lorem.characters(number: 19)
        fill_in 'blog[category]', with: Faker::Lorem.characters(number: 4)
        click_button '変更を保存'
      end

      it 'titleが正しく更新される' do
        expect(blog.reload.title).not_to eq @blog_old_title
      end
      it 'bodyが正しく更新される' do
        expect(blog.reload.body).not_to eq @blog_old_body
      end
      it 'categoryが正しく更新される' do
        expect(blog.reload.category).not_to eq @blog_old_category
      end
      it 'リダイレクト先が更新した投稿の詳細画面になっているか' do
        expect(current_path).to eq '/blogs/' + blog.id.to_s
      end
    end
  end
  
  describe '自分のユーザ詳細画面のテスト' do
    before do
      visit user_path(user)
    end
    
    context '表示のテスト' do
      it 'urlが正しい' do
        expect(current_path).to eq '/users/' + user.id.to_s
      end
      it '自分の名前と紹介文が表示される' do
        expect(page).to have_content user.name
        expect(page).to have_content user.introduction
      end
      it '投稿一覧に自分の投稿のtitleが表示され、リンクが正しい' do
        expect(page).to have_link blog.title, href: blog_path(blog)
      end
      it '投稿一覧に自分の投稿のbodyが表示される' do
        expect(page).to have_content blog.body
      end
      it '投稿一覧に他の人の投稿が表示されない' do
        expect(page).not_to have_link other_blog.title
        expect(page).not_to have_link other_blog.body
      end
      it '編集のリンクが表示されているか' do
        expect(page).to have_link '編集', href: edit_user_path(user)
      end
      it '退会のリンクが表示されているか' do
        expect(page).to have_link '退会', href: users_hide_path(user)
      end
    end
  end
end