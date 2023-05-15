class ApplicationController < ActionController::Base

  before_action :authenticate_user_or_admin!, except: [:top]


 def authenticate_user_or_admin!
  if request.path.start_with?('/admin')
   authenticate_admin!
  else
   authenticate_user!
  end
 end

end