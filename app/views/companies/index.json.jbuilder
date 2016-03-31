json.array!(@companies) do |company|
  json.extract! company, :id, :name, :full_name, :zip_code, :city, :street, :street_address, :nip, :regon
  json.url company_url(company, format: :json)
end
