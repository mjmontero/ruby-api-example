require 'spec_helper'
require 'resque_spec'

describe 'resque' do

  before do
    ResqueSpec.reset!
    @user = FactoryGirl.create(:user)
    patch "api/v1.0/users/#{@user.id}", {:new_password => "abc456", :confirm_password => "abc456"}
  end

  it 'creates job when password is changed' do    
    expect(Mailer).to have_queued(@user.email,'Password Changed', 'Your password has been successfully changed').in('mailing')
  end

end