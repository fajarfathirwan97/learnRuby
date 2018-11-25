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

  def getOrganization
    @organization = Organisasi.all
  end

  def add
    @user = User.new()
    self.getRoles
    self.getOrganization
  end

  def detail
    @user = User.where(["id = ?", params[:id]]).first
  end

  def update
    @user = User.where(["id = ?", params[:id]]).first
    self.getRoles
    self.getOrganization
  end

  def delete
    @user = User.where(["id = ?", params[:id]]).destroy_all
    redirect_to request.referer
  end

  def populateUser(model, params)
    model.first_name = params[:first_name]
    model.last_name = params[:last_name]
    model.phone = params[:phone]
    model.role_id = params[:role_id]
    model.organisasi_id = params[:organisasi_id]
    model.email = params[:email]
    return model
  end

  def uploadAvatar(avatar, prevAvatar)
    if (prevAvatar != nil && File.exists?("#{Rails.root}/public/uploads/avatar/#{prevAvatar.split("/uploads/avatar/")[1]}"))
      File.delete("#{Rails.root}/public/uploads/avatar/#{prevAvatar.split("/uploads/avatar/")[1]}")
    end
    imageExt = File.extname(avatar.original_filename)
    avatar.original_filename = "#{DateTime.now.strftime("%Q")}#{imageExt}"
    uploader = AvatarUploader.new
    uploader.store!(avatar)
    uploader.retrieve_from_store!(avatar.original_filename)
    return "#{request.domain}:#{request.port}/uploads/avatar/#{uploader.filename}"
  end

  def addProcess
    user = User.new
    user = self.populateUser(user, params)
    user.password = User.new(:password => params[:password]).encrypted_password
    if (params[:avatar])
      user.avatar = self.uploadAvatar(params[:avatar], nil)
    end
    if (user.valid?)
      flash[:success] = t("response.success_update")
      user.save
    else
      flash[:error] = user.errors
    end
    redirect_to request.referer
  end

  def updateProcess
    user = User.find_by(id: params[:id])
    user.first_name = params[:first_name]
    user.last_name = params[:last_name]
    user.phone = params[:phone]
    user.role_id = params[:role_id]
    user.email = params[:email]
    if (params[:avatar])
      user.avatar = self.uploadAvatar(params[:avatar], user.avatar)
    end
    if user.encrypted_password != params[:password]
      user.encrypted_password = User.new(:password => params[:password]).encrypted_password
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
      "REPLACE('#{actionButton}', '$id', id::varchar) as action",
    ]).limit(params[:length]).offset(params[:start])
      .order(self.column[params["order"]["0"]["column"].to_i] + " #{params["order"]["0"]["dir"]}")
    if params[:field] != "" && params[:operator] != ""
      datas = datas.where(["#{params[:field]} #{params[:operator]} ?", "%#{params[:q]}%"])
    end
    if params["organization_id"] && params["organizationDetail"]
      datas = datas.where(["organisasi_id = #{params["organization_id"]}"])
    end
    render json: {
      data: datas,
      draw: params[:draw],
      recordsFiltered: 0,
      recordsTotal: User.count(),
    }
  end
end
