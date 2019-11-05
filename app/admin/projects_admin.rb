Trestle.resource(:projects) do
  menu do
    group :project, priority: 1 do
      item :projects, icon: "fa fa-star", label: "作品"
    end
  end

  scope :all, -> { Project.order("sorting desc") }, default: true
  scope :feature, -> { Project.where(feature: true) }, label: "精選專案"
  scope :published, -> { Project.where(published: true) }, label: "已發佈"
  scope :unpublished, -> { Project.where(published: false) }, label: "未發佈"

  search do |query|
    if query
      Project.where("title LIKE ?", "%#{query}%")
    else
      Project.all
    end
  end

  # toolbar do
  #    default_buttons
  #    link_to "Custom Action", admin.path(:project, model, :custom_action), className: 'fa fa-custom'
  # end

  # Customize the table columns shown on the index view.
  #
  table do
      column :thumb, header: false, class: "col-thumb" do |img|
        # image_tag(img.thumb.url)
        admin_link_to(image_tag(img.thumb.url, class: "img-responsive"), img) if img.thumb?
      end
      column :title, link: true, header: "標題"
      # column :tag_list, sort: false, header: "分類"
      column :tags, format: :tags, sort: false, header: "分類" do |project|
        project.tags.map(&:name)
      end
      column :feature, align: :center, link: false, header: "精選專案" do |project|
        if project.featured then 
          # status_tag(icon("fa fa-check"), :success) 
          link_to(status_tag(icon("fa fa-check"), :success) , admin.path(:cancel_feature, id: project.id), method: :post, class: "action-btn")
        else 
          link_to(status_tag('none', :danger) , admin.path(:pub_feature, id: project.id), method: :post, class: "action-btn")
        end
            end
      column :published, align: :center, link: false, header: "發佈" do |project|      
        if project.status then 
          link_to(status_tag(icon("fa fa-check"), :success) , admin.path(:cancel_status, id: project.id), method: :post, class: "action-btn")
        else 
          link_to(status_tag('none', :danger) , admin.path(:pub_status, id: project.id), method: :post, class: "action-btn")
        end

        # status_tag(project.status, {  true => :success, false => :danger }[project.status] || :default)
      end
      column :sorting, header: "排序"
      column :created_at, header: "建立時間", align: :center
      column :updated_at, header: "最後更新時間", align: :center
      actions
  end

  # Customize the form fields shown on the new/edit views.
  #
  form do |project|
    tab "tw", label: "中文" do
      text_field :title, label: "標題", autocomplete: "off"
      editor     :desc, label: "描述"
    end

    tab "en", label: "英文" do
      text_field :title_en, label: "標題", autocomplete: "off"
      editor     :desc_en, label: "描述"
    end

    tab "Gallery" do
      form_group :gallerys, label: false do

        concat content_tag(:div, nil, :class => "custom-file"){
          raw_file_field :name, :multiple => true, name: "gallerys[name][]", class: "custom-file-input", id: "mutiupload"
          concat content_tag(:label, "Choose file", class: "custom-file-label", for: "customFile")
        }

        # raw_file_field :name, :multiple => true, name: "gallerys[name][]"

        mutinote = ["Upload a file less than 2MB. 可上傳多張","圖片尺寸 1920x1080px","照檔名排序, 0~9, a~z"]
        concat content_tag(:ul, nil, :class => 'help-block') {
          mutinote.collect do |item|
            content_tag(:li, item)
          end.join.html_safe
        }

        concat content_tag(:div, "",:id => "galleryList", :class => "galleryList")

        table GalleriesAdmin.table, collection: project.gallerys
      end

      concat(content_tag(:div, content_tag(:img),class: "upload-preview"))
    end

    sidebar do
      form_group :thumb, label: "作品縮圖", help: "圖片尺寸 710x400px" do
        concat content_tag(:div, nil, class: "previewimg", id: "thumbpreview"){ 
          concat image_tag(project.thumb.url, class: "thumbimg") if project.thumb.url
        }
        raw_file_field :thumb, class: "thumbimg"
      end

      # tag_select :tag_items
      select :tag_ids, Tag.all, { label: "類別" }, { multiple: true, data: { tags: true } }

      text_field :url, label: "連結", placeholder: "http://"

      text_field :video, label: "Media", help: "請輸入 vimeo 或 youtube 網址", placeholder: "http://vimeo.com/channels/staffpicks/52706924"

      #check_box :feature, label: "精選專案"
      form_group :feature, label: "精選專案" do
        # radio_button :feature, "Yes", 
        # radio_button :feature, "No", checked: true
        content_tag :fieldset, :class => "btn-group radio" do
          if project.feature == true
            concat content_tag(:input,'', type: "radio", value: true, name: 'project[feature]', id: "project_feature_0", checked: true)
            concat content_tag(:label,"是", for: 'project_feature_0', class: 'yes')
            concat content_tag(:input,'', type: "radio", value: false, name: 'project[feature]', id: "project_feature_1")
            concat content_tag(:label,"否", for: 'project_feature_1', class: 'no')
          else
            concat content_tag(:input,'', type: "radio", value: true, name: 'project[feature]', id: "project_feature_0")
            concat content_tag(:label,"是", for: 'project_feature_0', class: 'yes')
            concat content_tag(:input,'', type: "radio", value: false, name: 'project[feature]', id: "project_feature_1", checked: true)
            concat content_tag(:label,"否", for: 'project_feature_1', class: 'no')
          end
        end
      end

      form_group :published, label: "發佈文章" do
        content_tag :fieldset, :class => "btn-group radio" do
          if project.published == true
            concat content_tag(:input,'', type: "radio", value: true, name: 'project[published]', id: "project_published_0", checked: true)
            concat content_tag(:label,"是", for: 'project_published_0', class: 'yes')
            concat content_tag(:input,'', type: "radio", value: false, name: 'project[published]', id: "project_published_1")
            concat content_tag(:label,"否", for: 'project_published_1', class: 'no')
          else
            concat content_tag(:input,'', type: "radio", value: true, name: 'project[published]', id: "project_published_0")
            concat content_tag(:label,"是", for: 'project_published_0', class: 'yes')
            concat content_tag(:input,'', type: "radio", value: false, name: 'project[published]', id: "project_published_1", checked: true)
            concat content_tag(:label,"否", for: 'project_published_1', class: 'no')
          end
        end
      end

      text_field :sorting, label: "排序", help: '數字越大越前面', placeholder: 0, value: project.checksorting 
    end
  end #end form

  controller do 
    def create
      self.instance = admin.build_instance(admin.permitted_params(params), params) 

      if admin.save_instance(instance, params) 

        # 新增至gallery
        if params[:gallerys] != nil
          params[:gallerys]['name'].each do |img|
            @picture = instance.gallerys.create("name" => img)
          end
        end

        respond_to do |format|  
          format.html do  
            flash[:message] = flash_message("create.success", title: "Success!", message: "The %{lowercase_model_name} was successfully created.")  
            redirect_to_return_location(:create, instance, default: admin.instance_path(instance))  
          end 
          format.json { render json: instance, status: :created, location: admin.instance_path(instance) }  
          format.js 
        end 
      else  
        respond_to do |format|  
          format.html do  
            flash.now[:error] = flash_message("create.failure", title: "Warning!", message: "Please correct the errors below.") 
            render "new", status: :unprocessable_entity 
          end 
          format.json { render json: instance.errors, status: :unprocessable_entity } 
          format.js 
        end 
      end
    end # end create

    def update
      admin.update_instance(instance, admin.permitted_params(params), params)

      # 新增至gallery
      if params[:gallerys] != nil
        params[:gallerys]['name'].each do |img|
          @picture = instance.gallerys.create("name" => img)
        end
      end

      if admin.save_instance(instance, params)  
        respond_to do |format|  
          format.html do  
            flash[:message] = flash_message("update.success", title: "Success!", message: "The %{lowercase_model_name} was successfully updated.")  
            redirect_to_return_location(:update, instance, default: admin.instance_path(instance))  
          end 
          format.json { render json: instance, status: :ok }  
          format.js 
        end 
      else  
        respond_to do |format|  
          format.html do  
            flash.now[:error] = flash_message("update.failure", title: "Warning!", message: "Please correct the errors below.") 
            render "show", status: :unprocessable_entity  
          end 
          format.json { render json: instance.errors, status: :unprocessable_entity } 
          format.js 
        end 
      end

    end  # end update

    def pub_feature
      missile = admin.find_instance(params)
      missile.update("feature" => true);
      flash[:message] = flash_message("feature.success", title: "#{missile.title} 已設為精選專案", message: "The %{lowercase_model_name} was successfully updated.")  
      redirect_to admin.path(:index, id: missile)
    end

    def cancel_feature
      missile = admin.find_instance(params)
      missile.update("feature" => false)
      flash[:error] = flash_message("feature.cancel", title: "#{missile.title} 已取消精選專案", message: "The %{lowercase_model_name} was successfully updated.")  
      redirect_to admin.path(:index, id: missile)
    end

    def pub_status
      missile = admin.find_instance(params)
      missile.update("published" => true);
      flash[:message] = flash_message("published.success", title: "#{missile.title} 已發佈", message: "The %{lowercase_model_name} was successfully updated.")  
      redirect_to admin.path(:index, id: missile)
    end

    def cancel_status
      missile = admin.find_instance(params)
      missile.update("published" => false)
      flash[:error] = flash_message("published.cancel", title: "#{missile.title} 已取消發佈", message: "The %{lowercase_model_name} was successfully updated.")  
      redirect_to admin.path(:index, id: missile)
    end

    def export
      @projects = Project.all

      respond_to do |format|
        format.html
        format.csv { send_data @projects.to_csv, filename: "project-#{Date.today}.csv" }
      end
    end
  end

  routes do
    post :pub_feature, on: :member
    post :cancel_feature, on: :member
    post :pub_status, on: :member
    post :cancel_status, on: :member
    post :export, on: :collection
  end

  # By default, all parameters passed to the update and create actions will be
  # permitted. If you do not have full trust in your users, you should explicitly
  # define the list of permitted parameters.
  #
  # For further information, see the Rails documentation on Strong Parameters:
  #   http://guides.rubyonrails.org/action_controller_overview.html#strong-parameters
  #
  # params do |params|  
  def project_params
    # params.require(:project).permit(:title,:desc, :title_en, :desc_en)
    params.require(:project).permit(:title,:desc, :title_en, :desc_en, :tag_ids, :thumb)
  end 
end
