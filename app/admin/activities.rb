ActiveAdmin.register Activity do
  index do
    column :title
    column :created_at
    column :user
    column 'Activity Type' do |activity|
      activity.is_private? ? status_tag('private', :error) : status_tag('public', :ok)
    end
    default_actions
  end

  form do |f|
    f.inputs 'Details' do
      f.input :location_name
      f.input :date, as: :datepicker
      f.input :time
      f.input :age_min
      f.input :age_max
      f.input :description
    end
    f.actions
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

  filter :title
  filter :user_id
  filter :activity_type
  filter :location
  filter :country
  filter :state
  filter :city
  filter :age_min
  filter :age_max
end
