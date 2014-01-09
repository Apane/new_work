require 'spec_helper'

describe "conversations/edit" do
  before(:each) do
    @conversation = assign(:conversation, stub_model(Conversation,
      :author_id => 1,
      :companion_id => 1
    ))
  end

  it "renders the edit conversation form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form[action=?][method=?]", conversation_path(@conversation), "post" do
      assert_select "input#conversation_author_id[name=?]", "conversation[author_id]"
      assert_select "input#conversation_companion_id[name=?]", "conversation[companion_id]"
    end
  end
end
