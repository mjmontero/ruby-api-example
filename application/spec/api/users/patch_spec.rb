require 'spec_helper'


describe 'PATCH /api/users/:id' do
	before(:each) do
	  @user = FactoryGirl.create(:user)
	end
  it 'should update password' do
    patch "api/v1.0/users/#{@user.id}", {:new_password => "abc456", :confirm_password => "abc456"}

    expect(last_response.header["Content-Type"]).to eq("application/json")
    expect(last_response.status).to eq(200)

  end

  it 'should match confirmation' do
    patch "api/v1.0/users/#{@user.id}", {:new_password => "abc456", :confirm_password => "456abc"}

    expect(last_response.header["Content-Type"]).to eq("application/json")
    expect(last_response.status).to eq(400)

  end

end
