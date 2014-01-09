require 'spec_helper'

describe "conversations/show" do
  before(:each) do
    @conversation = assign(:conversation, stub_model(Conversation,
      :author_id => 1,
      :companion_id => 2
    ))
  end

  it "renders attributes in <p>" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(/1/)
    rendered.should match(/2/)
  end
end
