require 'spec_helper'

describe "messages/edit" do
  before(:each) do
    @message = assign(:message, stub_model(Message,
      :sender_id => 1,
      :receiver_id => 1,
      :body => "MyText",
      :parent_id => 1
    ))
  end

  it "renders the edit message form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form[action=?][method=?]", message_path(@message), "post" do
      assert_select "input#message_sender_id[name=?]", "message[sender_id]"
      assert_select "input#message_receiver_id[name=?]", "message[receiver_id]"
      assert_select "textarea#message_body[name=?]", "message[body]"
      assert_select "input#message_parent_id[name=?]", "message[parent_id]"
    end
  end
end
