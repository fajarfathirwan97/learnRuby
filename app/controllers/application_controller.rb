class ApplicationController < ActionController::Base
  def checkPermission
    if !((JSON.parse(current_user.role.permission).include? "*") || (JSON.parse(current_user.role.permission).include? "#{controller_name}##{action_name}") || "#{controller_name}##{action_name}" == "admin#index")
      head :forbidden
    end
    p controller_name, action_name
  end
end
