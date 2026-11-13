require "sidekiq/web"

# The Sidekiq dashboard used to be mounted with no protection at all.
# It now requires SIDEKIQ_WEB_USERNAME / SIDEKIQ_WEB_PASSWORD; without a
# password configured it stays closed for everybody.
Sidekiq::Web.use Rack::Auth::Basic, "Sidekiq" do |username, password|
  expected_password = ENV["SIDEKIQ_WEB_PASSWORD"].to_s
  next false if expected_password.empty?

  ActiveSupport::SecurityUtils.secure_compare(username, ENV["SIDEKIQ_WEB_USERNAME"].to_s) &
    ActiveSupport::SecurityUtils.secure_compare(password, expected_password)
end
