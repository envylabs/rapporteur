require 'spec_helper.rb'

describe "status routes" do
  it 'routes /status.json to statuses#show' do
    expect({ :get => '/status.json'}).to route_to({
      :action => 'show',
      :controller => 'statuses',
      :format => 'json',
    })
  end

  it 'does not route /status' do
    expect({ :get => '/status'}).to_not be_routable
  end

  it 'does not route /status.html' do
    expect({ :get => '/status.html'}).to_not be_routable
  end

  it 'does not route /status.xml' do
    expect({ :get => '/status.xml'}).to_not be_routable
  end
end
