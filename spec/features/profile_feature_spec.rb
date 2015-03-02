require 'rails_helper'

feature 'Profiles' do
  
  context 'a professional can create a profile' do
    it "should redirect to the new profile page after sign up" do
      visit '/'
      click_link 'Sign in'
      click_link 'Sign Up As A Professional'
      fill_in "Email", with: "professional_test@example.com"
      fill_in "Password", with: "12341234"
      fill_in "Password confirmation", with: "12341234"
      click_button 'Sign up'
      expect(page).to have_content("What do you think makes you suitable as a mentor for young people looking for a one day experience?
")
      expect(current_path).to eq new_profile_path
    end
  end

  context 'when a professional is logged in' do
      
    let(:professional) {create :professional }

    before do
      login_as(professional, :scope => :professional)
    end

    after do
      logout(:professional)
    end

    it "should allow a professional to create a profile" do
      visit new_profile_path
      fill_in "Name", with: "Emily"
      select "Software Engineer",  from: "Profession"
      fill_in "Company", with: "Makers Academy"
      fill_in "Work address", with: "Commercial Street, London"
      click_button 'Create Profile'
      expect(Profile.last.company).to eq "Makers Academy"
    end

  end

  context 'a professional must fill in the necessary fields to create a profile' do

    let(:professional) {create :professional}

    before do
      login_as(professional, :scope => :professional)     
      visit new_profile_path
    end

    after do
      logout(:professional)
    end

    it "should not allow a professional to create a profile unless the 'name' field is filled in" do
      select "Software Engineer", from: "Profession"
      fill_in "Company", with: "Makers Academy"
      fill_in "Work address", with: "Commercial Street, London"
      click_button 'Create Profile'
      expect(page).to have_content('Please provide your name')
    end

    it "should not allow a professional to create a profile unless the 'profession' field is filled in" do    
      fill_in "Name", with: "Emily"
      fill_in "Company", with: "Makers Academy"
      fill_in "Work address", with: "Commercial Street, London"
      click_button 'Create Profile'
      expect(page).to have_content("Please select your profession")
    end
  end

  context "a profile is half complete" do
    xit "should not be visible to students until complete" do
    end

    xit "a professional should be receive a message notifying them that their profile needs completing" do
    end
  end

  context "a professional wishes to edit or delete their profile" do
    let(:profile) { create :profile }
    let(:another_professional) { create(:professional, email: 'another@example.com') }
    let(:another_profile) { create(:profile, professional: another_professional) }

    before do
      login_as(profile.professional, :scope => :professional)
    end

    after do
      logout(:professional)
    end

    it "a professional can see a link to edit their profile" do
      visit profile_path(profile)
      expect(page).to have_content "Edit Profile" 
    end

    it "a professional can edit their profile" do
      visit profile_path(profile)
      click_link "Edit Profile"
      fill_in "Company", with: "My Company"
      click_button 'Update Profile'
      expect(page).to have_content("My Company")
    end

    it "a professional cannot edit another professional's profile" do
      visit profile_path(another_profile)
      expect(page).not_to have_content "Edit Profile"
    end

    it "a professional can see a link to delete their profile" do
      visit profile_path(profile)
      expect(page).to have_content "Delete Profile"
    end

    it "a professional can delete their profile" do
      visit profile_path(profile)
      click_link "Delete Profile"
      expect(current_path).to eq('/')
      expect(page).to have_content("Your profile has been deleted successfully")
    end

    it "a professional cannot delete another professional's profile" do
      visit profile_path(another_profile)
      expect(page).not_to have_content "Delete Profile"
    end
  end

  context 'a professional has a link to their profile' do

    let(:profile) {create :profile}

    it "upon logging in, a professional will be redirected to their profile" do
      visit '/'
      click_link 'Sign in'
      click_link 'Professional Sign in'
      fill_in "Email", with: profile.professional.email
      fill_in "Password", with: profile.professional.password
      click_button 'Log in'
      expect(current_path).to eq profile_path(profile)
    end

    xit "when logged in, a professional will have a link to their profile in the navbar" do
    end
  end

end