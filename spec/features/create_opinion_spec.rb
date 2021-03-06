describe 'Create Opinion', type: :feature do
  before :each do
    @user = User.create(username: 'sadie', email: 'sadie@mail.com', password: '123456',
                        password_confirmation: '123456')
  end

  it 'Create an opinion' do
    visit '/users/sign_in'
    fill_in 'user[login]', with: @user.username
    fill_in 'user[password]', with: @user.password
    click_button 'Log in'
    fill_in 'opinion[content]', with: 'This is a test opinion.'
    click_button 'Create Opinion'
    expect(page).to have_content 'Opinion created successfully.'
  end

  it 'Does not create an opinion' do
    visit '/users/sign_in'
    fill_in 'user[login]', with: @user.username
    fill_in 'user[password]', with: @user.password
    click_button 'Log in'
    fill_in 'opinion[content]', with: ''
    click_button 'Create Opinion'
    expect(page).to have_content 'Content is too short (minimum is 5 characters)'
  end
end
