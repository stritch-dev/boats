require 'spec_helper'

describe 'User' do 
  before do 
    @user = User.create(:name => "Ben", :email => "ben@notreal.no.no", :password => "test")
  end

  it 'correctly assigns name and email to a user' do
    expect(@user.name).to eq("Ben")
    expect(@user.email).to eq("ben@notreal.no.no")
  end

  it 'has a secure password' do
    expect(@user.authenticate("test")).to eq(@user)
  end

  it 'does not authenticate when user sumbits wrong password' do
    expect(@user.authenticate("dog")).to eq(false)
  end

end
