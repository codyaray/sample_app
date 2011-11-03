require 'spec_helper'

describe MicropostsController do
  render_views

  describe "for non-signed-in users" do
    it "should deny access to 'create'" do
      post :create
      response.should redirect_to(signin_path)
    end

    it "should deny access to 'destroy'" do
      delete :destroy, :id => 1
      response.should redirect_to(signin_path)
    end
    
    it "should allow access to 'index'" do
      get :index, :user_id => Factory(:user)
      response.should_not redirect_to(signin_path)
    end
  end

  describe "GET 'index'" do
    before(:each) do
      @user = test_sign_in(Factory(:user))
      @microposts = []
      50.times do
        @microposts << Factory(:micropost, :user => @user, :content => Faker::Lorem.sentence(5))
      end
    end
    
    it "should be successful" do
      get :index, :user_id => @user
      response.should be_successful
    end

    it "should have the right title" do
      get :index, :user_id => @user
      response.should have_selector("title", :content => "#{@user.name}'s microposts")
    end

    it "should have an element for each micropost" do
      get :index, :user_id => @user
      @microposts.each do |micropost|
        response.should have_selector("span.content", :content => micropost.content)
      end
    end
  end

  describe "POST 'create'" do
    before(:each) do
      @user = test_sign_in(Factory(:user))
    end

    describe "failure" do
      before(:each) do
        @attr = { :content => "" }
      end

      it "should not create a micropost" do
        lambda do
          post :create, :micropost => @attr
        end.should_not change(Micropost, :count)
      end

      it "should render the home page" do
        post :create, :micropost => @attr, :user_id => @user
        response.should render_template('pages/home')
      end
    end

    describe "success" do
      before(:each) do
        @attr = { :content => "Lorem ipsum" }
      end

      it "should create a micropost" do
        lambda do
          post :create, :micropost => @attr
        end.should change(Micropost, :count).by(1)
      end

      it "should redirect to the home page" do
        post :create, :micropost => @attr
        response.should redirect_to(root_path)
      end

      it "should have a flash message" do
        post :create, :micropost => @attr
        flash[:success].should =~ /micropost created/i
      end
    end

  end

  describe "DELETE 'destroy'" do
    
    describe "for an unauthorized user" do
      before(:each) do
        @user = Factory(:user)
        wrong_user = Factory(:user, :email => Factory.next(:email))
        test_sign_in(wrong_user)
        @micropost = Factory(:micropost, :user => @user)
      end
      
      it "should deny access" do
        delete :destroy, :id => @micropost
        response.should redirect_to(root_path)
      end
    end

    describe "for an authorized user" do
      before(:each) do
        @user = test_sign_in(Factory(:user))
        @micropost = Factory(:micropost, :user => @user)
      end

      it "should destroy the micropost" do
        lambda do
          delete :destroy, :id => @micropost
        end.should change(Micropost, :count).by(-1)
      end
    end

  end

end
