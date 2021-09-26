# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Userモデルのテスト', type: :model do
  describe 'バリデーションのチェック' do
    subject { user.valid? }
    let!(:other_user) { create(:user) }
    let(:user) { build(:user) }

    context 'nameカラム' do
      it '空欄ではない' do
        user.name = ''
        is_expected.to eq false
      end
      it '2文字以上であること。１文字は弾く' do
        user.name = Faker::Lorem.characters(number: 1)
        is_expected.to eq false
      end
      it '2文字以上であること。2文字は通す' do
        user.name = Faker::Lorem.characters(number: 2)
        is_expected.to eq true
      end
      it '20文字以内であること。20文字は通す' do
        user.name = Faker::Lorem.characters(number: 20)
        is_expected.to eq true
      end
      it '20文字以内であること。21文字は弾く' do
        user.name = Faker::Lorem.characters(number: 21)
        is_expected.to eq false
      end
      it '一意性があるか否か' do
        user.name = other_user.name
        is_expected.to eq false
      end
    end
    context 'introductionカラム' do
      it '50文字以内であるか。50文字は通す' do
        user.introduction = Faker::Lorem.characters(number: 50)
        is_expected.to eq true
      end
      it '50文字以内であるか。51文字は弾く' do
        user.introduction = Faker::Lorem.characters(number: 51)
        is_expected.to eq false
      end
    end
  end

  describe 'アソシエーション' do
    context 'blogモデル' do
      it '1:Nの関係か' do
        expect(User.reflect_on_association(:blogs).macro).to eq :has_many
      end
    end
    context 'blog_commentモデル' do
      it '1:Nの関係か' do
        expect(User.reflect_on_association(:blog_comments).macro).to eq :has_many
      end
    end
    context 'favoriteモデル' do
      it '1:Nの関係か' do
        expect(User.reflect_on_association(:favorites).macro).to eq :has_many
      end
    end
  end
end