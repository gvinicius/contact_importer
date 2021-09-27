require 'rails_helper'

RSpec.describe Api::V1::ImportsController, type: :controller do
  let(:user) { FactoryBot.create(:user) }
  let(:file) { fixture_file_upload(Rails.root.join("#{Rails.root}/spec/fixtures/sheet.csv"), 'sheet.csv', 'text/csv') }
  before do
    sign_in(user)
  end

  describe "POST #create" do
    it "activates the run operation" do
      expect_any_instance_of(Import).to receive(:run)

      post :create, params: { file: file }
    end
  end

  describe "GET #index" do
    it "returns http success" do
      get :index
      expect(response).to have_http_status(:success)
    end
  end
end
