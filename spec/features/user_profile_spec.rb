# frozen_string_literal: true
describe UserProfilesController, type: :feature do
  before { login }

  describe '#index GET /user_profiles' do
    context 'by user_name' do
      let(:url) { URI.parse(current_url) }
      let(:query) { URI.decode(url.query) }
      let!(:user) { create(:user, name: '山田太郎', entry_date: 1.months.ago) }
      let!(:user_profile) { create(:user_profile, user: user) }

      before do
        visit user_profiles_path
        fill_in '氏名', with: '山田太郎'
        click_button '検索'
      end

      it { expect(current_path).to eq user_profiles_path }
      it { expect(page).to have_selector 'div', text: '山田太郎' }
      it { expect(page).not_to have_selector 'div', text: 'やまだたろう' }
    end

    context 'by self_introduction' do
      let(:url) { URI.parse(current_url) }
      let(:query) { URI.decode(url.query) }
      let!(:user) { create(:user, name: '山田太郎', entry_date: 1.months.ago) }
      let!(:user_profile) { create(:user_profile, user: user, self_introduction: 'Rubyが得意です。') }

      before do
        visit user_profiles_path
        fill_in '自己紹介', with: 'Ruby'
        click_button '検索'
      end

      it { expect(current_path).to eq user_profiles_path }
      it { expect(page).to have_selector 'div', text: '山田太郎' }
      it { expect(page).not_to have_selector 'div', text: 'やまだたろう' }
    end

    context 'by user_entry_date' do
      let(:url) { URI.parse(current_url) }
      let(:query) { URI.decode(url.query) }
      let!(:user) { create(:user, entry_date: 1.months.ago) }
      let!(:user_profile) { create(:user_profile, user: user) }
      let!(:one_month_ago) { 1.months.ago.beginning_of_month.strftime('%Y年%m月') }
      let!(:two_month_ago) { 2.months.ago.beginning_of_month.strftime('%Y年%m月') }

      before do
        visit user_profiles_path
        select one_month_ago, from: '入社日'
        click_button '検索'
      end

      it { expect(current_path).to eq user_profiles_path }
      it { expect(page).to have_selector 'small', text: one_month_ago }
      it { expect(page).not_to have_selector 'small', text: two_month_ago }
    end
  end
end
