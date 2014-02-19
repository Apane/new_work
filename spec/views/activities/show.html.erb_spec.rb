require 'spec_helper'

describe "activities/show" do
  before(:each) do
    @activity = assign(:activity, stub_model(Activity,
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
    ))
  end

  it "renders attributes in <p>" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(/Title/)
    rendered.should match(/MyText/)
    rendered.should match(/Location/)
    rendered.should match(/Time/)
    rendered.should match(/1.5/)
    rendered.should match(/1.5/)
    rendered.should match(/Location/)
    rendered.should match(/Location Name/)
    rendered.should match(/false/)
    rendered.should match(/Postal Code/)
    rendered.should match(/Country/)
    rendered.should match(/State/)
    rendered.should match(/City/)
    rendered.should match(/1/)
    rendered.should match(/2/)
    rendered.should match(/3/)
    rendered.should match(/4/)
    rendered.should match(/5/)
    rendered.should match(/6/)
  end
end
