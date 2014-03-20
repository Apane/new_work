ActiveAdmin.register Message do
  index do
    selectable_column
    column :sender
    column(:receiver) {|m| link_to m.recipient.name, admin_user_path(m.recipient)}
    column(:read) {|m| m.is_new? ? status_tag('No', :false) : status_tag('Yes', :true) }
    column :conversation
    column :created_at
    default_actions
  end

  filter :sender
  filter :recipient
  filter :is_new
  filter :created_at

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
