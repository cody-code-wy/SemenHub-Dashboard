puts 'Adding dev seeds'
puts 'THIS SHOULD NOT SHOW IN PRODUCTION'

rands = (1..10).to_a

puts 'Creating Breeds'
5.times { FactoryBot.create(:breed) }
puts 'Creating Registrars'
Breed.all.each do |breed|
  next if breed.registrars.count > 0
  rands.sample.times { FactoryBot.create(:registrar, breed: breed) }
end
puts 'Creating Animals'
Breed.all.each do |breed|
  @sires = 4.times.collect { FactoryBot.create(:animal, :with_sire, :with_dam, is_male: true, breed: breed) }
  @dams  = 4.times.collect { FactoryBot.create(:animal, :with_sire, :with_dam, is_male: false, breed: breed) }
  6.times {
    FactoryBot.create(:animal, sire: @sires.sample, dam: @dams.sample, breed: breed)
  }
end
puts 'Creating Registrations'
Animal.all.each do |animal|
  Registrar.where(breed: animal.breed).each do |reg|
    next if [true, false, false].sample
    FactoryBot.create(:registration, animal: animal, registrar: reg)
  end
end
puts 'Creating Storage Facilities'
5.times { FactoryBot.create(:storage_facility, :with_adjustments) }
puts 'Creating Skus'
15.times { FactoryBot.create(:sku, animal: Animal.all.sample) }
185.times do
  seller = User.all.sample
  animal = Animal.all.sample
  sf = StorageFacility.all.sample
  FactoryBot.create(:sku, :with_countries, seller: seller, animal: animal, storagefacility: sf)
end
puts 'Set random Storage Facilities to require Administrative Approval'
10.times do
  sf = StorageFacility.all.sample
  sf.update(admin_required: true)
end
puts 'Creating custom commissions'
rands.sample.times do
  user = User.all.sample
  FactoryBot.create(:commission, user: user)
end
puts 'Adding Inventory Transactions to skus'
Sku.all.each do |sku|
  quantity = (1000..5000).to_a.sample
  FactoryBot.create(:inventory_transaction, sku: sku, quantity: quantity)
end
puts 'Adding fees to storage facilities'
StorageFacility.all.each do |sf|
  (0..5).to_a.sample.times do
    FactoryBot.create(:fee, storage_facility: sf)
  end
end
puts 'Creating Users'
25.times { FactoryBot.create(:user) }
puts 'Creating Purchases'
Purchase.states.keys.each do |state|
  10.times do
    user = User.all.sample
    purchase = FactoryBot.create(:purchase, state: state, user: user, created_at: Faker::Date.backward(30))
    if state == 'paid'
      purchase.update(
        authorization_code: Faker::Number.number(6),
        transaction_id: Faker::Number.number(11)
      )
    end
    if [true, false].sample
      purchase.line_items << FactoryBot.build_list(:line_item, rands.sample)
    end
    if purchase.state_before_type_cast >= 2
      purchase.shipments << FactoryBot.build_list(:shipment, rands.sample)
    end
    rands.sample.times do
      trans = FactoryBot.create(:inventory_transaction, sku: Sku.all.sample, quantity: Faker::Number.between(-100, -1))
      purchase.inventory_transactions << trans
    end
  end
end


puts 'Added dev seeds'
