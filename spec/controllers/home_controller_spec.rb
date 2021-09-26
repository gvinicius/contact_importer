require 'rails_helper'

RSpec.describe HomeController, type: :controller do

  describe "GET #index" do
    it "returns http success" do
      get :index
      expect(response).to have_http_status(:success)
    end
  end

  describe "GET #service_worker" do
    it "returns http success" do
      get :service_worker, format: :js
      expect(response).to have_http_status(:success)
    end
  end

end
