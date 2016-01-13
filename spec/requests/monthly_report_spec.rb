describe MonthlyReportsController, type: :request do
  let!(:report) { create(:monthly_report, :with_comments, :with_tags) }
  let(:user) { create(:user) }
  before { login user }

  describe '#index GET /monthly_reports' do
    before { get monthly_reports_path }
    it { expect(response).to have_http_status :success }
    it { expect(response).to render_template('monthly_reports/index') }
    it { expect(response.body).to match report.user.name }
  end

  describe '#show GET /monthly_reports/:id' do
    before { get monthly_report_path(report) }
    it { expect(response).to have_http_status :success }
    it { expect(response).to render_template('monthly_reports/show') }
    it { expect(response.body).to match report.user.name }
  end

  describe '#new GET /monthly_reports/new' do
    before { get new_monthly_report_path }
    it { expect(response).to have_http_status :success }
    it { expect(response).to render_template('monthly_reports/new') }
  end

  describe '#create POST /monthly_reports' do
    let(:new_report) { build(:monthly_report) }
    let(:report_params) { new_report.attributes.reject { |k, _| k =~ /id\z/ || k =~ /_at/ } }
    let(:user_report) { MonthlyReport.find_by(user: user) }

    context 'valid' do
      let(:post_params) { { monthly_report: report_params } }
      before { post monthly_reports_path, post_params }
      it { expect(response).to have_http_status :redirect }
      it { expect(user_report.present?).to eq true }
    end

    context 'invalid' do
      let(:post_params) { { monthly_report: report_params.except('target_month') } }
      before { post monthly_reports_path, post_params }
      it { expect(response).to have_http_status :success }
      it { expect(response).to render_template('monthly_reports/new') }
      it { expect(user_report.present?).to eq false }
    end
  end
end