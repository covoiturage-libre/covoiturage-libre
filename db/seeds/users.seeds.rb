user = User.new(
  email: 'admin@local',
  password: 'changeme',
  password_confirmation: 'changeme',
  role: 'admin',
)
user.try(:skip_confirmation!)
user.save!
