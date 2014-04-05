ActiveAdmin.register_page "Dashboard" do

  menu priority: 1, label: proc{ I18n.t("active_admin.dashboard") }

  content title: proc{ I18n.t("active_admin.dashboard") } do
    # div class: "blank_slate_container", id: "dashboard_default_message" do
    #   span class: "blank_slate" do
    #     span I18n.t("active_admin.dashboard_welcome.welcome")
    #     small I18n.t("active_admin.dashboard_welcome.call_to_action")
    #   end
    # end

    columns do
      column do
        panel "Last 10 users" do
          table_for User.last(10).map do |user|
            column(:full_name) {|user| link_to user.name, admin_user_path(user) }
            column(:completed) {|user| user.has_completed_profile? ? status_tag('yes', :ok) : status_tag("#{user.profile_completed}%", :error) }
            column(:confirmed) { |user| user.confirmed? ? status_tag('yes', :ok) : status_tag('no', :error) }
            column(:gender) {|u| User::GENDER[u.gender][0] if u.gender != nil}
            column(:last_sign_in_at) {|u| l u.last_sign_in_at, format: :short unless u.last_sign_in_at == nil}
            column :age
            column :ethnicity
            column :email
            column(:signed_up_at) {|u| l u.created_at, format: :short}
          end
        end
      end
    end

    columns do
      column do
        panel 'Last 10 events' do
          table_for Event.last(10).map do |event|
            column(:name) {|event| link_to((event.title.present? ? event.title : 'title missing'), admin_event_path(event)) }
            column :location
            column(:event_date) {|e| l e.event_date, format: :short}
            column(:date_added) {|e| l e.created_at, format: :short}
            column(:date_updated) {|e| l e.updated_at, format: :short}
          end
        end
      end
    end

 #add location, date, time, date added, date updated.

    # Here is an example of a simple dashboard with columns and panels.
    #
    # columns do
    #   column do
    #     panel "Recent Posts" do
    #       ul do
    #         Post.recent(5).map do |post|
    #           li link_to(post.title, admin_post_path(post))
    #         end
    #       end
    #     end
    #   end

    #   column do
    #     panel "Info" do
    #       para "Welcome to ActiveAdmin."
    #     end
    #   end
    # end
  end # content
end
