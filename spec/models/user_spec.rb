require "rails_helper"

describe User do

  before do
    @user = FactoryGirl.create(:user)
  end

  subject { @user }

  it { should be_valid }

  describe 'validations' do
    it { should validate_presence_of :email }
    it { should validate_presence_of :password }
    it { should validate_inclusion_of(:role).in_array(%w(admin)) }
  end

end
