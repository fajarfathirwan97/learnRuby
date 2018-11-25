class RoleController < ApplicationController
  before_action :authenticate_user!

  def column
    @column = ["name"]
  end

  def index
    @dataTableUrl = route_for(:roleDatatable)
  end

  def routeList
    @routeList = [
      "role#index",
      "role#detail",
      "role#add",
      "role#update",
      "role#datatable",
      "user#index",
      "user#detail",
      "user#add",
      "user#update",
      "role#delete",
      "user#delete",
      "user#datatable",
    ]
  end

  def add
    @role = Role.new
    self.routeList
  end

  def populateRole(model, params)
    model.name = params[:name]
    model.permission = params[:permission].to_json
    return model
  end

  def addProcess
    role = Role.new
    role = self.populateRole(role, params)
    if role.valid?
      flash[:success] = t("response.success_update")
      role.save
    else
      flash[:error] = role.errors
    end
    redirect_to request.referer
  end

  def detail
    @role = Role.where(["id = ?", params[:id]]).first
  end

  def update
    self.detail
    self.routeList
    @routeList = (JSON.parse(@role.permission) + @routeList) - (JSON.parse(@role.permission) & @routeList)
  end

  def updateProcess
    role = Role.find_by(id: params[:id])
    role = self.populateRole(role, params)
    if role.valid?
      flash[:success] = t("response.success_update")
      role.save
    else
      flash[:error] = role.errors
    end
    redirect_to request.referer
  end

  def delete
    @user = Role.where(["id = ?", params[:id]]).destroy_all
    redirect_to request.referer
  end

  def datatable
    actionButton = "<button class=\"btn btn-default btn-detail\" data-id=\"$id\"><i class=\"fa fa-info\"></i></button>"
    actionButton += "<button class=\"btn btn-default btn-delete\" data-id=\"$id\"><i class=\"fa fa-trash\"></i></button>"
    actionButton += "<button class=\"btn btn-default btn-update\" data-id=\"$id\"><i class=\"fa fa-edit\"></i></button>"
    datas = Role.select([
      "id",
      "name",
      "REPLACE('#{actionButton}', '$id', id::varchar) as action",
    ]).limit(params[:length]).offset(params[:start])
      .order(self.column[params["order"]["0"]["column"].to_i] + " #{params["order"]["0"]["dir"]}")
    if params[:field] != "" && params[:operator] != ""
      datas = datas.where(["#{params[:field]} #{params[:operator]} ?", "%#{params[:q]}%"])
    end
    render json: {
      data: datas,
      draw: params[:draw],
      recordsFiltered: datas.length,
      recordsTotal: Role.count(),
    }
  end
end
