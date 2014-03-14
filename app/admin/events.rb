ActiveAdmin.register Event do
  index do
    column :title
    column :created_at
    column :user
    default_actions
  end


  form do |f|
    f.inputs 'Details' do
      f.input :country, :as => :string
      f.input :city
    end
    f.actions
  end

  # See permitted parameters documentation:
  # https://github.com/gregbell/active_admin/blob/master/docs/2-resource-customization.md#setting-up-strong-parameters
  #
  # permit_params :list, :of, :attributes, :on, :model
  #
  # or
  #
  # permit_params do
  #  permitted = [:permitted, :attributes]
  #  permitted << :other if resource.something?
  #  permitted
  # end

end
