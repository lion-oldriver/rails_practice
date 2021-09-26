# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Blogモデルのテスト', type: :model do
  describe 'バリデーションチェック' do
    subject { blog.valid? }
    let!(:user) { create(:user) }
    let(:blog) { build(:blog, user_id: user.id) }

    context 'title' do
      it 'タイトルは空でないか' do
        blog.title = ''
        is_expected.to eq false
      end
    end
    context "body" do
      it '本文は空でないか' do
        blog.body = ''
        is_expected.to eq false
      end
    end
    context 'image' do
      it 'イメージはあるか' do
        blog.image = ''
        is_expected.to eq false
      end
    end
  end
end