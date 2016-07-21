class MonthlyReportsController < ApplicationController
  def index
    references = [{ user: :group }, { monthly_report_tags: :tag }]
    @q = MonthlyReport.includes(references).ransack(search_params)
    @monthly_reports = @q.result(distinct: true).released.page params[:page]
  end

  def user
    @target_year = (params[:target_year] || Date.current.year).to_i
    @report_user = User.find(params[:user_id])
    @monthly_reports = user_reports_in_year(@target_year, @report_user)
  end

  def show
    @monthly_report = MonthlyReport.includes(comments: :user).find(params[:id])
  end

  def new
    target_month = params[:target_month] || current_user.report_registrable_to.beginning_of_month
    @monthly_report = current_user.monthly_reports.build(target_month: target_month)
  end

  def create
    @monthly_report = MonthlyReport.new(permitted_params) do |report|
      report.user   = current_user
      assign_relational_params(report)
    end
    shipped_at_was = @monthly_report.shipped_at_was
    if @monthly_report.save
      monthly_report_notify(shipped_at_was)
      redirect_to @monthly_report
    else
      flash_errors(@monthly_report)
      render :new
    end
  end

  def edit
    @monthly_report = current_user.monthly_reports.includes(monthly_report_tags: :tag).find params[:id]
  end

  def update
    @monthly_report = current_user.monthly_reports.find(params[:id])
    @monthly_report.assign_attributes(permitted_params)
    assign_relational_params(@monthly_report)
    shipped_at_was = @monthly_report.shipped_at_was
    if @monthly_report.save
      monthly_report_notify(shipped_at_was)
      redirect_to @monthly_report
    else
      flash_errors(@monthly_report)
      render :edit
    end
  end

  def copy
    @monthly_report = MonthlyReport.new(target_month: params[:target_month], user: current_user).set_prev_monthly_report!
    render :new
  end

  private

  def flash_errors(monthly_report)
    flash.now[:error] = monthly_report.errors.full_messages
  end

  def assign_relational_params(report)
    report.status = params[:wip] ? :wip : :shipped
    report.monthly_working_processes = working_processes(report)
    report.tags = monthly_report_tags
  end

  def working_processes(monthly_report)
    return [] if params[:working_process].blank?

    params[:working_process]
      .select { |process| MonthlyWorkingProcess.processes.keys.include?(process) }
      .map { |process| MonthlyWorkingProcess.new(monthly_report: monthly_report, process: process) }
  end

  def monthly_report_tags
    tags = params[:monthly_report][:monthly_report_tags].try!(:split, ',').try!(:map) do |tag|
      Tag.find_or_create_by(name: tag.strip)
    end
    tags || []
  end

  def user_reports_in_year(year, report_user)
    reports = MonthlyReport.year(year).includes(:user).where(user: report_user)

    (1..12).map do |month|
      target_month = Date.new(year, month, 1)
      report = reports.find { |r| r.target_month == target_month }
      report ||= MonthlyReport.new(user: report_user, target_month: target_month)
      report.registrable_term? ? report : nil
    end.compact
  end

  def permitted_params
    params.require(:monthly_report).permit(
      :target_month,
      :project_summary,
      :business_content,
      :looking_back,
      :next_month_goals,
    )
  end

  def search_params
    return unless params[:q]
    params[:q][:tags_name_in] = params[:q][:tags_name_in].split(',')

    search_conditions = [
      :user_group_id_eq,
      :user_name_cont,
      tags_name_in: [],
      monthly_working_processes_process_in: [],
    ]

    params.require(:q).permit(search_conditions)
  end

  def monthly_report_notify(shipped_at_was)
    return unless shipped_at_was.blank?
    Notify.monthly_report_registration(@monthly_report.user.id, @monthly_report.id).deliver_now
  end
end
