Trestle.resource(:tags) do
	menu do
		group :project do
			item :tags, icon: "fa fa-tags", label: "作品類別"
		end
	end

	# Customize the table columns shown on the index view.
	#
	table do
	  column :name, header: "類別名稱"
	  column :sorting, header: "排序"
      column :publish, align: :center, link: false, header: "發佈" do |tag|
      	if tag.publish then 
        	link_to(status_tag(icon("fa fa-check"), :success) , admin.path(:cancel_status, id: tag.id), method: :post, class: "action-btn")
      	else
        	link_to(status_tag('none', :danger) , admin.path(:pub_status, id: tag.id), method: :post, class: "action-btn")
      	end
      end      
	  # column :created_at, align: :center
	  # column :updated_at, header: "Last Updated", align: :center
	  actions
	end

	form dialog: true do |type|
		text_field :name, label: "類別名稱"
		text_field :sorting, label: "排序"
	end

	controller do 
	    def pub_status
	      missile = admin.find_instance(params)
	      missile.update("publish" => true);
	      flash[:message] = flash_message("publish.success", title: "#{missile.name} 已發佈", message: "The %{lowercase_model_name} was successfully updated.")  
	      redirect_to admin.path(:index, id: missile)
	    end

	    def cancel_status
	      missile = admin.find_instance(params)
	      missile.update("publish" => false)
	      flash[:error] = flash_message("publish.cancel", title: "#{missile.name} 已取消發佈", message: "The %{lowercase_model_name} was successfully updated.")  
	      redirect_to admin.path(:index, id: missile)
	    end
	end

	routes do
	    post :pub_status, on: :member
	    post :cancel_status, on: :member
	end
end