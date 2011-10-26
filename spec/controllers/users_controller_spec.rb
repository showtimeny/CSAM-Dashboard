require 'spec_helper'

describe UsersController do
  render_views
  
  describe "GET 'show'" do
    
    before(:each) do
      @user = Factory(:user)
    end
      
    it "should be successful" do
      get :show, :id => @user.id
      response.should be_successful
    end
    
    it "should find the right user" do
      get :show, :id => @user.id
      assigns(:user).should == @user
    end
    
    it "should have the right title" do
      get :show, :id => @user
      response.should have_selector('title', :content => @user.name)
    end
    
    it "should have the user's name" do
      get :show, :id => @user
      response.should have_selector('h1', :content => @user.name)
    end
    
    it "should have an avatar" do
      get :show, :id => @user
      response.should have_selector('h1>img', :class => "gravatar")
    end
    
    it "should have the right URL" do
      get :show, :id => @user
      response.should have_selector('td>a', :content => user_path(@user), :href => user_path(@user))
    end
  end
  
  describe "GET 'new'" do
    it "should be successful" do
      get :new
      response.should be_success
    end
    
    it "should have the right title" do
         get :new
         response.should have_selector('title', :content => "Sign up")
     end  
  end
  
  describe "POST 'create'" do
    
    # FAILURE!!!
    describe "failure" do
      # Every time the browser posts create, make a hash with empty strings as elements...
      before(:each) do
        @attr = {:name => "", :email => "", :password => "", :password_confirmation => ""}
      end
      
      it "should not create a user" do
        lambda do
          post :create, :user => @attr
        end.should_not change(User, :count)
      end
      
      it "should have the right title" do
        post :create, :user => @attr
        response.should have_selector('title', :content => "Sign up")
      end
      
      it "should render the 'new page" do
        post :create, :user => @attr
        response.should render_template('new')
      end
    end
    
    #SUCCESS!!!!
    describe "success" do
      before(:each) do
        @attr = {:name => "New User", :email => "new@example.com", :password => "examplesaur", :password_confirmation => "examplesaur"}
      end
      
      it "should create a user" do
        lambda do
          post :create, :user => @attr
          response.should change(User, :count).by(1)
        end
      end
      
      it "should redirect to the user show page" do
        post :create, :user => @attr
        response.should redirect_to(user_path(assigns(:user)))
      end
      
      it "should have a welcome message" do
        post :create, :user => @attr
        flash[:success].should =~ /welcome to the sample app/i
      end
      
      it "should sign the user in" do
        post :create, :user => @attr
        controller.should be_signed_in
      end
    end
      
  end
  
  describe "GET 'edit'" do
    
    before(:each) do
      @user = Factory(:user)
      test_sign_in(@user)
    end
    
    it "should be successful" do
      get :edit, :id => @user
      response.should be_success
    end
    
    it "should have the right title" do
      get :edit, :id => @user
      response.should have_selector(:title, :content => "Edit user")
    end
    
    it "should have a link to change the gravatar" do
      get :edit, :id => @user
      gravatar_url = "http://gravatar.com/emails"
      response.should have_selector("a", :href => "http://gravatar.com/emails", :content => "change")
    end
  end
  
  describe "PUT 'update'" do
    before(:each) do
      @user = Factory(:user)
      test_sign_in(@user)
    end
    
    describe "failure" do
      before(:each) do
        @attr = { :name => "", :email => "", :password => "", :password_confirmation => "" }
      end
      
      it "should render the edit page" do
        put :update, :id => @user, :user => @attr
        response.should render_template("edit")
      
      end
      
      it "should have the right title" do
        put :update, :id => @user, :user => @attr
        response.should have_selector("title", :content => "Edit user")
      end
      
    end
    
    describe "success" do
      before(:each) do
        @attr = {:name => "New Name", :email => "user@example.com", :password => "admin", :password_confirmation => "admin" }
      end
      
      it "should change the user's attributes" do
        put :update, :id => @user, :user => @user
        @user.reload
        @user.name.should == @attr[:name]
        @user.email.should == @attr[:email]
      end
      
      it "should redirect to the user show page" do
        put :update, :id => @user, :user => @user
        response.should redirect_to(user_path(@user))
      end
      
      it "should have a flash message" do
        put :update, :id => @user, :user => @user
        flash[:success].should =~ /updated/
      end
    end
    
    describe "authentication of edit/update pages" do
      before(:each) do
        @user = Factory(:user)
      end
      
      describe "for non-signed-in users" do
        
        it "should deny them access to 'edit'"
          get :edit, :id => @user
          response.should redirect_to(signin_path)
        end
        
        it "should deny them access to 'update'" do
          get :edit, :id => @user, :user = {}
          response.should redirect_to(signin_path)
        end
        
      end
    end
  end
end

