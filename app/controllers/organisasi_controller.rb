class OrganisasiController < ApplicationController
  before_action :authenticate_user!

  def column
    @column = ["name"]
  end

  def index
    @dataTableUrl = route_for(:organisasiDatatable)
  end

  def detail
    @data = Organisasi.find_by(id: params["id"])
  end

  def update
    self.detail
  end

  def add
    @data = Organisasi.new
  end

  def updateProcess
    organization = Organisasi.find_by(id: params["id"])
    organization = self.populateOrganization(organization, params)
    if (params[:logo])
      organization.logo = self.uploadLogo(params[:logo], organization.logo)
    end
    if (organization.valid?)
      flash[:success] = t("response.success_update")
      organization.save
    else
      flash[:error] = organization.errors
    end
    redirect_to request.referer
  end

  def populateOrganization(model, params)
    model.name = params[:name]
    model.email = params[:email]
    model.phone = params[:phone]
    model.website = params[:website]
    return model
  end

  def uploadLogo(logo, prevlogo)
    if (prevlogo != nil && File.exists?("#{Rails.root}/public/uploads/avatar/#{prevlogo.split("/uploads/avatar/")[1]}"))
      File.delete("#{Rails.root}/public/uploads/avatar/#{prevlogo.split("/uploads/avatar/")[1]}")
    end
    imageExt = File.extname(logo.original_filename)
    logo.original_filename = "#{DateTime.now.strftime("%Q")}#{imageExt}"
    uploader = AvatarUploader.new
    uploader.store!(logo)
    uploader.retrieve_from_store!(logo.original_filename)
    return "#{request.domain}:#{request.port}/uploads/avatar/#{uploader.filename}"
  end

  def addProcess
    organization = Organisasi.new
    organization = self.populateOrganization(organization, params)
    if (params[:logo])
      organization.logo = self.uploadLogo(params[:logo], nil)
    end
    if (organization.valid?)
      flash[:success] = t("response.success_update")
      organization.save
    else
      flash[:error] = organization.errors
    end
    redirect_to request.referer
  end

  def delete
    def delete
      @user = User.where(["id = ?", params[:id]]).destroy_all
      redirect_to request.referer
    end
  end

  def datatable
    actionButton = "<button class=\"btn btn-default btn-detail\" data-id=\"$id\"><i class=\"fa fa-info\"></i></button>"
    actionButton += "<button class=\"btn btn-default btn-delete\" data-id=\"$id\"><i class=\"fa fa-trash\"></i></button>"
    actionButton += "<button class=\"btn btn-default btn-update\" data-id=\"$id\"><i class=\"fa fa-edit\"></i></button>"
    datas = Organisasi.select([
      "id",
      "name",
      "email",
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
      recordsTotal: Organisasi.count(),
    }
  end
end
