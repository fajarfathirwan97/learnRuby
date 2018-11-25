class ApplicationController < ActionController::Base
  def checkPermission
    if !((JSON.parse(current_user.role.permission).include? "*") || (JSON.parse(current_user.role.permission).include? "#{controller_name}##{action_name}"))
      head :forbidden
    end
    p (JSON.parse(current_user.role.permission).include? "#{controller_name}##{action_name}"), "kkkk"
  end
end
