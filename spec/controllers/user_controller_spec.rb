require 'spec_helper'
require 'pry-byebug'

describe UserController do

  before do
    @good_params = {
      :name => "bob",
      :email => "bob@bob.test.com",
      :password => "bobpass"
    }

    @fred_params = {
      :name => "fred",
      :email => "fred@fred.test.com",
      :password => "fredpass"
    }

    @fred = User.create(@fred_params)

    @raven = Boat.create({name: 'Raven', size_description: 'four'})
    @heart = Boat.create({name: 'Heart', size_description: 'eight'})
  end

  describe "Signup Page" do
    it 'loads the signup page' do
      get '/signup'
      expect(last_response.status).to eq(200)
    end

    it 'directs user to list of boats page after successful signup' do
      post '/signup', @params
      expect(last_response.location).to include("/boats")
    end

    it 'does not let a user sign up without a name' do
      params = @good_params
      params[:name] = "" 

      post '/signup', params

      expect(last_response.location).to include('/signup')
    end

    it 'does not let a user sign up without an email' do
      params = @good_params
      params[:email] = "" 

      post '/signup', params
      expect(last_response.location).to include('/signup')
    end

    it 'does not let a user sign up without a password' do
      params = @good_params
      params[:password] = "" 

      post '/signup', params
      expect(last_response.location).to include('/signup')
    end

    # TODO  change this test to look for form and button.
    it 'is hidden from logged in users. User is redirected to /boats' do
      login @fred

      get '/signup'

      expect(page.current_path).to eq('/boats')
    end
  end

  describe "login" do
    it 'loads the login page' do
      get '/login'
      expect(last_response.status).to eq(200)
    end

    it 'loads the boats list after login' do
      login @fred

      expect(page.current_path).to include("/boats")
    end

    it 'does not let user view login page if already logged in' do
      login @fred
      
      get '/login'

      expect(page.current_path).to eq('/boats')
    end
  end

  describe "logout" do
    it "lets a user logout if they are already logged in" do
      login @fred

      get '/logout'

      expect(last_response.location).to include("/login")
    end

    it 'does not let a user logout if not logged in' do
      get '/logout'
      expect(last_response.location).to include("/")
    end

    it 'directs non-loggedin users to the login page' do
      get '/boats'
      expect(last_response.location).to include("/login")
    end

    it 'does load /boats if user is logged in' do
      login @fred

      expect(page.current_path).to eq('/boats')
    end
  end

  describe 'index action' do
    context 'logged in' do
      it 'lets a user view the boat list if logged in' do

        login @fred

        visit "/boats"
        expect(page.body).to include(@raven.name)
        expect(page.body).to include(@heart.name)
      end
    end

    context 'logged out' do
      it 'does not let a user view the boats index if not logged in' do
        get '/boats'
        expect(last_response.location).to include("/login")
      end
    end
  end

  describe 'View New Boat Form: ' do
    context 'If user is logged in, ' do
      it 'the form is visible' do
        login @fred
        visit '/boats/new'
        expect(page.status_code).to eq(200)
      end

      it 'let user create a boat' do
        login @fred

        visit '/boats/new'
        fill_in(:name, :with => 'Speed')
        select 'eight', :from => 'size_description'
        click_button 'submit'

        new_boat = Boat.find_by(:name => "Speed")
        expect(new_boat).to be_instance_of(Boat)
        expect(new_boat.size_description).to eq("eight")
        expect(page.status_code).to eq(200)
      end
    end

    context 'If user is not logged in, ' do
      it 'do not let user view new boat form' do
        get '/boats/new'
        expect(last_response.location).to include("/login")
      end
    end
  end

  describe 'Show Action:' do
    context 'when users are logged in' do
      it 'they can view the details of a single boat' do
        login @fred
        visit "/boats/#{@raven.id}"

        expect(page.status_code).to eq(200)
        expect(page.body).to include(@raven.name)
        expect(page.body).to include(@raven.size_description)
        expect(page.body).to include("Edit")
        expect(page.body).to include("Delete")
      end
    end

    context "when users are viewing a boat's details, " do
      it 'they have the options to edit and delete that boat' do
        login @fred
        visit "/boats/#{@raven.id}"
        expect(page.body).to include("/boats/edit/#{@raven.id}")
        expect(page.body).to include("/boats/delete/#{@raven.id}")
      end
    end



    context 'logged out' do
      it 'does not let a user view a boat' do
        get "/boats/#{@raven.id}"
        expect(last_response.location).to include("/login")
      end
    end
  end

  def login(user)
    visit '/login'
    fill_in(:name, :with => user.name)
    fill_in(:password, :with => user.password)
    click_button 'submit'
  end

end
