ActiveAdmin.register Report do
  index do
    selectable_column
    column :user
    column :reportable_type
    column :reportable
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

  # filter :email
  # filter :first_name
  # filter :last_name
  # filter :gender, as: :select, collection: User::GENDER.invert
  # filter :occupation
  # filter :ethnicity
  # filter :education
  # filter :zip
  # filter :last_sign_in_at
  # filter :created_at
  # filter :updated_at
end
