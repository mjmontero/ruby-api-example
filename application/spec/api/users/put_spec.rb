require 'spec_helper'


describe 'PUT /api/users/:id' do

	before(:each) do
	  @user = FactoryGirl.create(:user)
	end
  it 'should update one user' do
    put "api/v1.0/users/#{@user.id}", {:first_name => "new name", :last_name => "new lastname"}

    expect(last_response.header["Content-Type"]).to eq("application/json")
    expect(last_response.status).to eq(200)
  end



end
