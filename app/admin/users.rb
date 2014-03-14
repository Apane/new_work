ActiveAdmin.register User do
  index do
    column :name
    column :email
    column(:confirmed) {|u| u.confirmed? ? status_tag('confirmed', :ok) : status_tag('not confirmed', :error) }
    column(:profile_completed) {|u| u.has_completed_profile? ? status_tag("#{u.profile_completed}%", :ok) : status_tag("#{u.profile_completed}%", :error)}
    column :created_at
    default_actions
  end

  # See permitted parameters documentation:
  # https://github.com/gregbell/active_admin/blob/master/docs/2-resource-customization.md#setting-up-strong-parameters
  #
  permit_params :all
  #
  # or
  #
  # permit_params do
  #  permitted = [:permitted, :attributes]
  #  permitted << :other if resource.something?
  #  permitted
  # end

  filter :email
  filter :first_name
  filter :last_name

end
