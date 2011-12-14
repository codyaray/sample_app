class PagesController < ApplicationController
  def home
    @title = "Home"
    if signed_in?
      @user = current_user
      @micropost = @user.microposts.build
      @feed_items = @user.feed.paginate(:page => params[:page])
    end
  end

  def contact
    @title = "Contact"
  end
  
  def about
    @title = "About"
  end

  def help
    @title = "Help"
  end

end
