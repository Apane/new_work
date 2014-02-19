require 'spec_helper'

describe "activities/new" do
  before(:each) do
    assign(:activity, stub_model(Activity,
      :title => "MyString",
      :description => "MyText",
      :location => "MyString",
      :time => "MyString",
      :lat => 1.5,
      :lng => 1.5,
      :location => "MyString",
      :location_name => "MyString",
      :activity_type => false,
      :postal_code => "MyString",
      :country => "MyString",
      :state => "MyString",
      :city => "MyString",
      :frequency_id => 1,
      :category_id => 1,
      :gender => 1,
      :ethnicity_id => 1,
      :age_min => 1,
      :age_max => 1
    ).as_new_record)
  end

  it "renders new activity form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form[action=?][method=?]", activities_path, "post" do
      assert_select "input#activity_title[name=?]", "activity[title]"
      assert_select "textarea#activity_description[name=?]", "activity[description]"
      assert_select "input#activity_location[name=?]", "activity[location]"
      assert_select "input#activity_time[name=?]", "activity[time]"
      assert_select "input#activity_lat[name=?]", "activity[lat]"
      assert_select "input#activity_lng[name=?]", "activity[lng]"
      assert_select "input#activity_location[name=?]", "activity[location]"
      assert_select "input#activity_location_name[name=?]", "activity[location_name]"
      assert_select "input#activity_activity_type[name=?]", "activity[activity_type]"
      assert_select "input#activity_postal_code[name=?]", "activity[postal_code]"
      assert_select "input#activity_country[name=?]", "activity[country]"
      assert_select "input#activity_state[name=?]", "activity[state]"
      assert_select "input#activity_city[name=?]", "activity[city]"
      assert_select "input#activity_frequency_id[name=?]", "activity[frequency_id]"
      assert_select "input#activity_category_id[name=?]", "activity[category_id]"
      assert_select "input#activity_gender[name=?]", "activity[gender]"
      assert_select "input#activity_ethnicity_id[name=?]", "activity[ethnicity_id]"
      assert_select "input#activity_age_min[name=?]", "activity[age_min]"
      assert_select "input#activity_age_max[name=?]", "activity[age_max]"
    end
  end
end
