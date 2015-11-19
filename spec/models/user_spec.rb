# == Schema Information
#
# Table name: users
#
#  id                     :integer          not null, primary key
#  name                   :string
#  group_id               :integer
#  employee_code          :string
#  email                  :string
#  entry_date             :date
#  beginner_flg           :boolean
#  deleted_at             :datetime
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#  encrypted_password     :string           default(""), not null
#  reset_password_token   :string
#  reset_password_sent_at :datetime
#  remember_created_at    :datetime
#  sign_in_count          :integer          default(0), not null
#  current_sign_in_at     :datetime
#  last_sign_in_at        :datetime
#  current_sign_in_ip     :inet
#  last_sign_in_ip        :inet
#

describe User, type: :model do
  describe 'Validations' do
    subject { build(:user) }

    it { is_expected.to be_valid }

    it { is_expected.to validate_presence_of(:name) }
    it { is_expected.to validate_length_of(:name).is_at_most(32) }
    it { is_expected.to validate_presence_of(:employee_code) }
    it { is_expected.to validate_uniqueness_of(:employee_code) }
    it { is_expected.to validate_presence_of(:email) }
    it { is_expected.to validate_presence_of(:entry_date) }
  end
end
