require 'spec_helper'

describe "messages/edit" do
  before(:each) do
    @message = assign(:message, stub_model(Message,
      :conversation_id => 1,
      :sender_id => 1,
      :recipient_id => 1,
      :body => "MyText"
    ))
  end

  it "renders the edit message form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form[action=?][method=?]", message_path(@message), "post" do
      assert_select "input#message_conversation_id[name=?]", "message[conversation_id]"
      assert_select "input#message_sender_id[name=?]", "message[sender_id]"
      assert_select "input#message_recipient_id[name=?]", "message[recipient_id]"
      assert_select "textarea#message_body[name=?]", "message[body]"
    end
  end
end
