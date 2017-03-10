require 'spec_helper'
require 'resque_spec'

describe 'resque' do

  before do
    ResqueSpec.reset!
    post "api/v1.0/users", {:first_name => "Test", :last_name => "User", :email => "test@user.com", :password => "abc123"}
  end

  it 'creates job when user is created' do    
    expect(Mailer).to have_queued('test@user.com','New account', 'Your account has been successfully created').in('mailing')
  end

end