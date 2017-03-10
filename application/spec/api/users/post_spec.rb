require 'spec_helper'


describe 'POST /api/users' do
  it 'should create one user' do
    post "api/v1.0/users", {:first_name => "Test", :last_name => "User", :email => "test@user.com", :password => "abc123"}

    expect(last_response.header["Content-Type"]).to eq("application/json")
    expect(last_response.status).to eq(201)

  end

  it 'should require first_name' do
    post "api/v1.0/users", {:last_name => "User", :email => "test@user.com", :password => "abc123"}

    expect(last_response.header["Content-Type"]).to eq("application/json")
    expect(response_body[:error_type]).to eq("validation")
    expect(last_response.status).to eq(400)

  end

  it 'should require last_name' do
    post "api/v1.0/users", {:first_name => "Test", :email => "test@user.com", :password => "abc123"}

    expect(last_response.header["Content-Type"]).to eq("application/json")
    expect(response_body[:error_type]).to eq("validation")
    expect(last_response.status).to eq(400)

  end

  it 'should require email' do
    post "api/v1.0/users", {:first_name => "Test", :last_name => "User", :password => "abc123"}

    expect(last_response.header["Content-Type"]).to eq("application/json")
    expect(response_body[:error_type]).to eq("validation")
    expect(last_response.status).to eq(400)

  end

  it 'should require password' do
    post "api/v1.0/users", {:first_name => "Test", :last_name => "User", :email => "test@user.com"}

    expect(last_response.header["Content-Type"]).to eq("application/json")
    expect(response_body[:error_type]).to eq("validation")
    expect(last_response.status).to eq(400)

  end


end
