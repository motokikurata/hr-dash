# frozen_string_literal: true

# == Schema Information
#
# Table name: user_profiles
#
#  id                :integer          not null, primary key
#  user_id           :integer          not null
#  self_introduction :text
#  blood_type        :integer          default("blood_blank"), not null
#  birthday          :date
#  created_at        :datetime         not null
#  updated_at        :datetime         not null
#

FactoryGirl.define do
  factory :user_profile do
    association :user
    self_introduction Faker::Lorem.paragraph
    blood_type { UserProfile.blood_types.keys.sample }
    birthday { Faker::Date.between(100.years.ago, Date.today) }
  end
end
