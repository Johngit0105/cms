require 'rails_helper'

RSpec.describe 'sessions', type: :feature do
  describe '/login' do
    before do
      visit_page '/login'
    end

    it 'logs in with valid username and password' do
      expect(find_field('Email')['autofocus']).to eq 'autofocus'
      fill_in 'Email', with: user.email
      fill_in 'Password', with: user.password

      click_button 'Login'

      it_should_be_on_home_page
      it_should_have_success_alert_with 'Signed in successfully.'
    end

    it 'accepts spaces in email' do
      fill_in 'Email', with: "  #{user.email} "
      fill_in 'Password', with: user.password

      click_button 'Login'

      it_should_be_on_home_page
      it_should_have_success_alert_with 'Signed in successfully.'
    end

    it 'ignores case for email 'do
      fill_in 'Email', with: user.email.upcase
      fill_in 'Password', with: user.password

      click_button 'Login'

      it_should_be_on_home_page
      it_should_have_success_alert_with 'Signed in successfully.'
    end

    it 'does not allow invalid email' do
      fill_in 'Email', with: new_email
      fill_in 'Password', with: user.password

      click_button 'Login'

      expect(current_path).to eq '/login'
      it_should_have_error_alert_with 'Invalid email or password.'
    end

    it 'does not allow invalid password' do
      fill_in 'Email', with: user.email
      fill_in 'Password', with: new_password

      click_button 'Login'

      expect(current_path).to eq '/login'
      it_should_have_error_alert_with 'Invalid email or password.'
    end

    it 'does not allow user from another site' do
      new_user = FactoryGirl.create(:user)

      fill_in 'Email', with: new_user.email
      fill_in 'Password', with: new_user.password

      click_button 'Login'

      expect(current_path).to eq '/login'
      expect(page.status_code).to eq 200
      it_should_have_error_alert_with 'Invalid email or password.'
    end

    it 'locks out user after 5 attempts' do
      expect {
        4.times do
          fill_in 'Email', with: user.email
          fill_in 'Password', with: new_password
          click_button 'Login'
          it_should_have_error_alert_with 'Invalid email or password.'
        end

        fill_in 'Email', with: user.email
        fill_in 'Password', with: new_password
      }.to_not change{ActionMailer::Base.deliveries.size}

      expect {
        click_button 'Login'
      }.to change{ActionMailer::Base.deliveries.size}.by(1)

      it_should_have_error_alert_with 'Invalid email or password.'

      email = ActionMailer::Base.deliveries.last
      expect(email.from).to eq ["noreply@#{site.host}"]
      expect(email.to).to eq [user.email]
      expect(email.subject).to eq 'Unlock instructions'

      token = user.unlock_token
      link = "http://#{site.host}/users/unlock?unlock_token=#{token}"
      email_body = email.body.raw_source
      expect(email_body).to have_content 'Your account has been locked'
      expect(email_body).to have_link 'Unlock my account', link
    end

    it 'has link in footer' do
      visit_page '/home'

      within('#footer_links') do
        click_link 'Login'
      end

      expect(current_path).to eq '/login'
    end
  end

  it_behaves_like 'logged in user' do
    let(:go_to_url) { '/home/edit' }

    context 'user removed from site' do
      before do
        user.sites = []
        user.save!
      end

      it_behaves_like 'restricted page'
    end

    context 'after 30 days' do
      before do
        Timecop.travel Time.now + 31.days
      end

      after do
        Timecop.return
      end

      it_behaves_like 'restricted page'
    end
  end

  describe '/logout' do
    let(:go_to_url) { '/home' }

    it_behaves_like 'logged in user' do
      it 'logs out from link in topbar' do
        visit_page '/home'

        within('#topbar') do
          click_link 'Logout'
        end

        it_should_be_on_home_page
        it_should_have_success_alert_with 'Signed out successfully.'
      end

      it 'logs out from link in footer' do
        within('#footer_links') do
          click_link 'Logout'
        end

        it_should_be_on_home_page
        it_should_have_success_alert_with 'Signed out successfully.'
      end
    end
  end
end
