require 'spec_helper.rb'

describe "status routes" do
  it 'routes /_status to statuses#show' do
    p Rails.application.routes.routes.inspect
    { :get => '/status'}.should route_to(:controller => 'status', :action => 'show')
  end
end
