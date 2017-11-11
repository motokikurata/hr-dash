# frozen_string_literal: true
# == Schema Information
#
# Table name: monthly_report_likes
#
#  id                :integer          not null, primary key
#  user_id           :integer          not null
#  monthly_report_id :integer          not null
#  created_at        :datetime         not null
#  updated_at        :datetime         not null
#

class MonthlyReportLike < ApplicationRecord
  belongs_to :user
  belongs_to :monthly_report

  validates :user, presence: true
  validates :monthly_report, presence: true
end