class UserController < ApplicationController
  before_action :authenticate_user!

  def column
    @column = ["full_name", "email"]
  end

  def index
    @users = User.limit(10)
    @dataTableUrl = route_for(:userDatatable)
  end

  def datatable
    datas = User.select([
      "id",
      "email",
      "CONCAT(first_name,' ',last_name) as full_name",
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
