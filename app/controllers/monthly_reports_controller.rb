class MonthlyReportsController < ApplicationController
  def index
  end

  def show
    @monthly_report = MonthlyReport.find(params[:id])
  end

  def new
    target_month = Time.current.beginning_of_month
    @monthly_report = MonthlyReport.new(target_month: target_month)
  end

  def create
    @monthly_report = MonthlyReport.new(permitted_params) do |report|
      report.user = current_user
    end

    if @monthly_report.save
      redirect_to @monthly_report
    else
      render :new
    end
  end

  private

  def permitted_params
    params.require(:monthly_report).permit(
      :target_month,
      :project_summary,
      :business_content,
      :looking_back,
      :next_month_goals,
    )
  end
end
