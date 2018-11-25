class UserController < ApplicationController
  before_action :authenticate_user!

  def column
    @column = ["full_name", "email"]
  end

  def index
    @dataTableUrl = route_for(:userDatatable)
  end

  def getRoles
    @roles = Role.all
  end

  def add
    @user = User.new()
    self.getRoles
  end

  def detail
    @user = User.where(["id = ?", params[:id]]).first
  end

  def update
    @user = User.where(["id = ?", params[:id]]).first
    self.getRoles
  end

  def addProcess
    image = params[:avatar]
    pp image
  end

  def updateProcess
    user = User.find_by(id: params[:id])
    user.first_name = params[:first_name]
    user.last_name = params[:last_name]
    user.phone = params[:phone]
    user.role_id = params[:role_id]
    user.email = params[:email]
    if user.encrypted_password != params[:password]
      user.encrypted_password = User.generate_token(params[:password])
    end
    if (user.valid?)
      flash[:success] = t("response.success_update")
      user.save
    else
      flash[:error] = user.errors
    end
    redirect_to request.referer
  end

  def datatable
    actionButton = "<button class=\"btn btn-default btn-detail\" data-id=\"$id\"><i class=\"fa fa-info\"></i></button>"
    actionButton += "<button class=\"btn btn-default btn-delete\" data-id=\"$id\"><i class=\"fa fa-trash\"></i></button>"
    actionButton += "<button class=\"btn btn-default btn-update\" data-id=\"$id\"><i class=\"fa fa-edit\"></i></button>"
    datas = User.select([
      "id",
      "email",
      "CONCAT(first_name,' ',last_name) as full_name",
      "REPLACE('#{actionButton}', '$id', id::char) as action",
    ]).limit(params[:length]).offset(params[:start])
      .order(self.column[params["order"]["0"]["column"].to_i] + " #{params["order"]["0"]["dir"]}")
    if params[:field] != "" && params[:operator] != ""
      datas = datas.where(["#{params[:field]} #{params[:operator]} ?", "%#{params[:q]}%"])
    end
    render json: {
      data: datas,
      draw: params[:draw],
      recordsFiltered: 0,
      recordsTotal: User.count(),
    }
  end
end
