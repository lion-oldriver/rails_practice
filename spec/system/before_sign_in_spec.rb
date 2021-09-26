# frozen_string_literal: true

require 'rails_helper'

describe 'トップページ' do
  describe 'Aboutページのテスト' do
    before do
      visit about_path
    end

    context '表示内容の確認' do
      it 'urlは正しいか' do
        expect(current_path).to eq '/about'
      end
    end
  end

  describe 'ヘッダーのテスト(ログイン前）' do
    before do
      visit new_user_session_path
    end

    context '表示内容のテスト' do
      it 'sign inのリンクはあるか' do
        signin_link = find_all('a')[0].native.inner_text
        expect(signin_link).to match(/sign in/i)
      end
      it 'sign upのリンクはあるか' do
        signup_link = find_all('a')[1].native.inner_text
        expect(signup_link).to match(/sign up/i)
      end
    end

    context 'リンクの遷移先のテスト' do
      it 'sign inのリンクは正しいか' do
        signin_link = find_all('a')[0].native.inner_text
        click_link signin_link
        expect(page).to have_current_path new_user_session_path
      end
      it 'sign upのリンクは正しいか' do
        signup_link = find_all('a')[1].native.inner_text
        click_link signup_link
        expect(page).to have_current_path new_user_registration_path
      end
    end
  end

  describe 'ユーザ新規登録' do
    before do
      visit new_user_registration_path
    end

    context '表示内容の確認' do
      it 'urlは正しいか' do
        expect(current_path).to eq '/users/sign_up'
      end
      it 'nameフォームがあるか' do
        expect(page).to have_field 'user[name]'
      end
      it 'emailフォームがあるか' do
        expect(page).to have_field 'user[email]'
      end
      it 'passwordフォームがあるか' do
        expect(page).to have_field 'user[password]'
      end
      it 'password_confirmationフォームがあるか' do
        expect(page).to have_field 'user[password_confirmation]'
      end
      it 'sign upボタンがあるか' do
        expect(page).to have_button 'Sign up'
      end
    end

    context '新規登録成功時のテスト' do
      before do
        fill_in 'user[name]', with: Faker::Lorem.characters(number: 10)
        fill_in 'user[email]', with: Faker::Internet.email
        fill_in 'user[password]', with: 'password'
        fill_in 'user[password_confirmation]', with: 'password'
      end

      it '正しく登録されるか' do
        expect{ click_button 'Sign up' }.to change(User.all, :count).by(1)
      end
      it '遷移先がブログ一覧になっているか' do
        click_button 'Sign up'
        expect(current_path).to eq '/blogs'
      end
    end
  end

  describe 'ユーザーログインのテスト' do
    let(:user) { create(:user) }

    before do
      visit new_user_session_path
    end

    context '表示内容の確認' do
      it 'urlは正しいか' do
        expect(current_path).to eq '/users/sign_in'
      end
      it 'nameフォームはあるか' do
        expect(page).to have_field 'user[name]'
      end
      it 'passwordフォームはあるか' do
        expect(page).to have_field 'user[password]'
      end
      it 'Log inボタンがあるか' do
        expect(page).to have_button 'Log in'
      end
    end
    context 'ログイン時のテスト' do
      before do
        fill_in 'user[name]', with: user.name
        fill_in 'user[password]', with: user.password
        click_button 'Log in'
      end

      it '遷移後がブログ一覧になっているか' do
        expect(current_path).to eq '/blogs'
      end
    end
    context 'ログイン失敗時のテスト' do
      before do
        fill_in 'user[name]', with: ''
        fill_in 'user[password]', with: ''
      end

      it 'ログインに失敗し、ログイン画面にリダイレクトされる' do
        expect(current_path).to eq new_user_session_path
      end
    end
  end
  describe 'ヘッダーのテスト（ログイン後）' do
    let(:user) { create(:user) }
    before do
      visit new_user_session_path
      fill_in 'user[name]', with: user.name
      fill_in 'user[password]', with: user.password
      click_button 'Log in'
    end

    context 'ヘッダーの表示の確認' do
      it 'タイトルが表示されているか' do
        expect(page).to have_content 'CARAVAN'
      end
      it 'homeのリンクがあるか' do
        home_link = find_all('a')[0].native.inner_text
        expect(home_link).to match(/Home/i)
      end
      it 'Aboutのリンクがあるか' do
        about_link = find_all('a')[1].native.inner_text
        expect(about_link).to match(/About/i)
      end
      it 'Newのリンクがあるか' do
        new_link = find_all('a')[2].native.inner_text
        expect(new_link).to match(/New/i)
      end
      it 'log outのリンクがあるか' do
        logout_link = find_all('a')[3].native.inner_text
        expect(logout_link).to match(/log out/i)
      end
    end

    context 'リンクの遷移先が正しいか' do
      it 'Homeリンクは正しいか' do
        home_link = find_all('a')[0].native.inner_text
        click_link home_link
        expect(page).to have_current_path blogs_path
      end
      it 'Aboutリンクは正しいか' do
        about_link = find_all('a')[1].native.inner_text
        click_link about_link
        expect(page).to have_current_path about_path
      end
      it 'Newリンクは正しいか' do
        new_link = find_all('a')[2].native.inner_text
        click_link new_link
        expect(page).to have_current_path new_blog_path
      end
    end
  end
end