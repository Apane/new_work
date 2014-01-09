require 'spec_helper'

describe "messages/show" do
  before(:each) do
    @message = assign(:message, stub_model(Message,
      :conversation_id => 1,
      :sender_id => 2,
      :recipient_id => 3,
      :body => "MyText"
    ))
  end

  it "renders attributes in <p>" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(/1/)
    rendered.should match(/2/)
    rendered.should match(/3/)
    rendered.should match(/MyText/)
  end
end
