json.array!(@tools_cards) do |tools_card|
  json.extract! tools_card, :id, :employee_id_id
  json.url tools_card_url(tools_card, format: :json)
end
