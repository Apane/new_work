require 'spec_helper'

describe "activities/index" do
  before(:each) do
    assign(:activities, [
      stub_model(Activity,
        :title => "Title",
        :description => "MyText",
        :location => "Location",
        :time => "Time",
        :lat => 1.5,
        :lng => 1.5,
        :location => "Location",
        :location_name => "Location Name",
        :activity_type => false,
        :postal_code => "Postal Code",
        :country => "Country",
        :state => "State",
        :city => "City",
        :frequency_id => 1,
        :category_id => 2,
        :gender => 3,
        :ethnicity_id => 4,
        :age_min => 5,
        :age_max => 6
      ),
      stub_model(Activity,
        :title => "Title",
        :description => "MyText",
        :location => "Location",
        :time => "Time",
        :lat => 1.5,
        :lng => 1.5,
        :location => "Location",
        :location_name => "Location Name",
        :activity_type => false,
        :postal_code => "Postal Code",
        :country => "Country",
        :state => "State",
        :city => "City",
        :frequency_id => 1,
        :category_id => 2,
        :gender => 3,
        :ethnicity_id => 4,
        :age_min => 5,
        :age_max => 6
      )
    ])
  end

  it "renders a list of activities" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => "Title".to_s, :count => 2
    assert_select "tr>td", :text => "MyText".to_s, :count => 2
    assert_select "tr>td", :text => "Location".to_s, :count => 2
    assert_select "tr>td", :text => "Time".to_s, :count => 2
    assert_select "tr>td", :text => 1.5.to_s, :count => 2
    assert_select "tr>td", :text => 1.5.to_s, :count => 2
    assert_select "tr>td", :text => "Location".to_s, :count => 2
    assert_select "tr>td", :text => "Location Name".to_s, :count => 2
    assert_select "tr>td", :text => false.to_s, :count => 2
    assert_select "tr>td", :text => "Postal Code".to_s, :count => 2
    assert_select "tr>td", :text => "Country".to_s, :count => 2
    assert_select "tr>td", :text => "State".to_s, :count => 2
    assert_select "tr>td", :text => "City".to_s, :count => 2
    assert_select "tr>td", :text => 1.to_s, :count => 2
    assert_select "tr>td", :text => 2.to_s, :count => 2
    assert_select "tr>td", :text => 3.to_s, :count => 2
    assert_select "tr>td", :text => 4.to_s, :count => 2
    assert_select "tr>td", :text => 5.to_s, :count => 2
    assert_select "tr>td", :text => 6.to_s, :count => 2
  end
end
