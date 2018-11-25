class RoleController < ApplicationController
  before_action :authenticate_user!
  before_action :checkPermission

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
      "role#delete",
      "user#index",
      "user#detail",
      "user#add",
      "user#update",
      "user#delete",
      "user#datatable",
      "organisasi#index",
      "organisasi#detail",
      "organisasi#add",
      "organisasi#delete",
      "organisasi#update",
      "organisasi#datatable",
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
    datas = Role.select([
      "id",
      "name",
    ]).limit(params[:length]).offset(params[:start])
      .order(self.column[params["order"]["0"]["column"].to_i] + " #{params["order"]["0"]["dir"]}")
    if params[:field] != "" && params[:operator] != ""
      datas = datas.where(["#{params[:field]} #{params[:operator]} ?", "%#{params[:q]}%"])
    end
    datas = JSON.parse(datas.to_json)
    datas.each_with_index do |data, index|
      if (JSON.parse(current_user.role.permission).include? "*") || (JSON.parse(current_user.role.permission).include? "role#detail")
        actionButton = "<button class=\"btn btn-default btn-detail\" data-id=#{data["id"]}><i class=\"fa fa-info\"></i></button>"
      end
      if (JSON.parse(current_user.role.permission).include? "*") || (JSON.parse(current_user.role.permission).include? "role#delete")
        actionButton += "<button class=\"btn btn-default btn-delete\" data-id=#{data["id"]}><i class=\"fa fa-trash\"></i></button>"
      end
      if (JSON.parse(current_user.role.permission).include? "*") || (JSON.parse(current_user.role.permission).include? "role#update")
        actionButton += "<button class=\"btn btn-default btn-update\" data-id=#{data["id"]}><i class=\"fa fa-edit\"></i></button>"
      end
      data[:action] = actionButton
    end
    render json: {
      data: datas,
      draw: params[:draw],
      recordsFiltered: datas.count,
      recordsTotal: Role.count(),
    }
  end
end
