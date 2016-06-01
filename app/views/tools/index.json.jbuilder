json.array!(@tools) do |tool|
  json.extract! tool, :id, :name, :quantity, :has_card
  json.url tool_url(tool, format: :json)
end
