# == Schema Information
#
# Table name: admin_users
#
#  id                     :integer          not null, primary key
#  email                  :string           default(""), not null
#  encrypted_password     :string           default(""), not null
#  reset_password_token   :string
#  reset_password_sent_at :datetime
#  remember_created_at    :datetime
#  sign_in_count          :integer          default(0), not null
#  current_sign_in_at     :datetime
#  last_sign_in_at        :datetime
#  current_sign_in_ip     :inet
#  last_sign_in_ip        :inet
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#

describe AdminUser do
  it { expect(subject).to respond_to(:email) }
  it { expect(subject).to respond_to(:encrypted_password) }
  it { expect(subject).to respond_to(:reset_password_token) }
  it { expect(subject).to respond_to(:reset_password_sent_at) }
  it { expect(subject).to respond_to(:remember_created_at) }
  it { expect(subject).to respond_to(:sign_in_count) }
  it { expect(subject).to respond_to(:current_sign_in_at) }
  it { expect(subject).to respond_to(:last_sign_in_at) }
  it { expect(subject).to respond_to(:current_sign_in_ip) }
  it { expect(subject).to respond_to(:last_sign_in_ip) }

  let(:admin_user) do
    AdminUser.new(
      email: email,
      encrypted_password: password,
      reset_password_token: token,
      reset_password_sent_at: sent_at,
      remember_created_at: r_created_at,
      sign_in_count: sign_in_count,
      current_sign_in_at: c_sign_in_at,
      last_sign_in_at: l_sign_in_at,
      current_sign_in_ip: c_sign_in_ip,
      last_sign_in_ip: l_sign_in_ip
    )
  end
  let(:email) { 'hoge@example.com' }
  let(:password) { 'hoge' }
  let(:token) { 'huga' }
  let(:sent_at) { '2010-01-01 00:00:00' }
  let(:r_created_at) { '2010-01-01 00:00:00' }
  let(:sign_in_count) { 1 }
  let(:c_sign_in_at) { '2010-01-01 00:00:00' }
  let(:l_sign_in_at) { '2010-01-01 00:00:00' }
  let(:c_sign_in_ip) { '192.168.1.1' }
  let(:l_sign_in_ip) { '192.168.255.255' }

  describe '.new' do
    subject { admin_user }

    context 'when correct params' do
      pending 'deviseの:registableをつけたら有効にする' do
        it { is_expected.to be_valid }
      end
    end

    context 'when incorrect params ' do
      context 'with unformat mailaddress.' do
        let(:email) { '@huga..@ex..ample.com' }
        it { is_expected.not_to be_valid }
      end

      context 'with email is too long.' do
        let(:email) { 'huga@expamle.com' + 'a' * 255 }
        it { is_expected.not_to be_valid }
      end
    end
  end
end