puts 'Creating Roles and Permissions'
role = Role.find_by_name :superuser
perms = [Permission.find_or_create_by(name: "superuser", description: "All Permissions Granted")]
if role
  role.permissions.destroy_all
  role.permissions << perms
else
  Role.create(name: "superuser", permissions: perms)
end

role = Role.find_by_name :default
perms = [Permission.find_or_create_by(name: "login", description: "Allows user to login"), Permission.find_or_create_by(name: "purchase", description: "Allows user to purchase items"), Permission.find_or_create_by(name: :"use_purchases_controller", description: "Allows user to view their purchases (invoices and recipts)")]
if role
  role.permissions.destroy_all
  role.permissions << perms
else
  Role.create(name: "default", permissions: perms)
end

role = Role.find_by_name :seller
perms = [Permission.find_or_create_by(name: "addStock", description: "Allows user to register own transactions")]
if role
  role.permissions.destroy_all
  role.permissions << perms
else
  Role.create(name: "seller", permissions: perms )
end
puts 'Created Roles and Permissions'
