ActiveAdmin.register User do
  index do
    selectable_column
    column :name
    column :email
    column(:gender) {|u| User::GENDER[u.gender]}
    column(:confirmed) {|u| u.confirmed? ? status_tag('yes') : status_tag('no') }
    column(:profile_completed) {|u| u.has_completed_profile? ? status_tag("#{u.profile_completed}%", :ok) : status_tag("#{u.profile_completed}%", :error)}
    column(:disabled?) {|u| u.disabled? ? status_tag('yes') : status_tag('no')}
    column(:created_at) {|u| (l u.created_at, format: :short)}
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
  filter :gender, as: :select, collection: User::GENDER.invert
  filter :occupation
  filter :ethnicity
  filter :education
  filter :zip
  filter :last_sign_in_at
  filter :created_at
  filter :updated_at
end
