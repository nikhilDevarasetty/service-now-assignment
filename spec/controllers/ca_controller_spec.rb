require 'rails_helper'

RSpec.describe CaController, type: :controller do
  before(:each) do
    CaGenerator.generate_certificates
  end

  it 'should return server expiration date' do
    get :expiration
    expiration_date = JSON.parse(response.body, symbolize_names: true)[:expiration_date].to_date
    expect(response.status).to eq(200)
    expect(expiration_date).to eq(1.week.from_now.to_date)
  end
end
