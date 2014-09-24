json.groups @maneged_groups do |mg|
  json.group_id mg.id
  json.name mg.name

  json.admin do
    json.id mg.admin.id
    json.email mg.admin.email
    json.mobile_number mg.admin.mobile_number
    json.first_name mg.admin.first_name
    json.last_name mg.admin.last_name
  end

  json.members mg.users do |u|
    json.id u.id
    json.email u.email
    json.mobile_number u.mobile_number
    json.first_name u.first_name
    json.last_name u.last_name
  end
end