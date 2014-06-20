require File.join(File.dirname(__FILE__), '..', 'spec_helper')

describe Rack::Throttle::Daily do
  include Rack::Test::Methods

  def app
    @target_app ||= example_target_app
    @app ||= Rack::Throttle::Daily.new(@target_app, :max_per_day => 3)
  end

  it "should be allowed if not seen this day" do
    get "/foo"
    expect(last_response.body).to show_allowed_response
  end

  it "should be allowed if seen fewer than the max allowed per day" do
    2.times { get "/foo" }
    expect(last_response.body).to show_allowed_response
  end

  it "should not be allowed if seen more times than the max allowed per day" do
    4.times { get "/foo" }
    expect(last_response.body).to show_throttled_response
  end

  # TODO mess with time travelling and requests to make sure no overlap
end
