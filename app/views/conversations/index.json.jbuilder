json.array!(@conversations) do |conversation|
  json.extract! conversation, :author_id, :companion_id
  json.url conversation_url(conversation, format: :json)
end