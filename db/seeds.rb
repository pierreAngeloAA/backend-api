# Demo user for local development. Idempotent: running `db:seed` again keeps
# the same user instead of failing on the unique email.
User.find_or_create_by!(email: "test@example.com") do |user|
  user.password = "password123"
end
