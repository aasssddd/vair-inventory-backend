# inventory.coffee
express = require 'express'
router = express.Router()
{sqz} = require '../persistence/database'
models = sqz.models
###
path: inventory
###
r = router.route '/'
###
	list all inventories
###
r.get (req, res) ->
	sqz.models.inventory.findAll({include: [sqz.models.category, sqz.models.brand, sqz.models.type]}).then (inventories) ->
		res.json inventories

###
create new inventory
###
r.post (req, res)->
	models = sqz.models

	# find if inventory type exists
	user_name = "William Chen"
	category = req.body.category
	brand = req.body.brand
	type = req.body.type
	id = req.body.id
	serial = req.body.sn



	models.category.findOrCreate {where: {category_name: category}, defaults: { category_name: category, creator: user_name}}
	.spread (categoryObj, isCreatedCategory) ->
		console.log "category created"
		models.brand.findOrCreate {where: {brand_name: brand}, include: [{ model: models.category, where: {category_name: categoryObj.category_name}}], defaults: {brand_name: brand, creator: user_name}}
		.spread (brandObj, isCreatedBrand) ->
			console.log "brand created"
			models.type.findOrCreate {where: {type_name: type}, include: [{model: models.brand, where: {brand_name: brandObj.brand_name}}], defaults: {type_name: type, creator: user_name}}
			.spread (typeObj, isCreatedType) ->
				console.log "type created"
				# concate inventory type
				if isCreatedType
					brandObj.addType typeObj

				if isCreatedBrand
					categoryObj.addBrand brandObj

				models.inventory.create {
					assetId: id
					sn: serial
					owner: user_name
					status: 'NEW'
				}
				.then (inventoryObj) ->
					categoryObj.addInventory inventoryObj
					brandObj.addInventory inventoryObj
					typeObj.addInventory inventoryObj
					res.json {"state": "OK", "code": 0}
	.catch (err) ->
		console.log "Err...#{err}"
		res.json {"state": "Error", "code": 999, "throw": err}



s = router.route '/id/:id'
###
update inventory's metadata by id
###
s.put (req, res) ->
	user_name = "William Chen"
	id = req.params.id
	aid = req.body.id
	category = req.body.category
	brand = req.body.brand
	type = req.body.type
	sn = req.body.sn
	owner = req.body.owner
	reason = req.body.comment
	status = req.body.status
	models = sqz.models

	if type? or brand? or category?
		if not type? and (category? and not brand?)
			return res.json { "status" : "Error", "code" : 999, "throw" : "cannot change category or brand"}

	# find by Id
	models.inventory.findOne { where : { assetId : id}, include : [models.category, models.brand, models.type]}
	.catch (err) ->
		res.json {"state": "Error", "code": 999, "throw": err}
	.then (inventoryObj) ->
		if not inventoryObj?
			return res.json {"status": "Error", "code" : 999, "throw" : "inventory not exists"}

		# change aid
		if aid? and id != aid
			inventoryObj.aid = aid

		# change sn
		if sn? and inventoryObj.sn != sn
			inventoryObj.sn = sn

		# change status
		currentStatus = inventoryObj.status
		if status?
			inventoryObj.status = status

		# change owner
		if owner? and inventoryObj.owner != owner
			models.inventory_history.create {
				transfer_from: inventoryObj.owner,
				transfer_to: owner, 
				operator: user_name, 
				reason: reason,
				status_before: currentStatus,
				new_status: if status? then status else currentStatus
			}
			.then (history) ->
				beforeOwner = inventoryObj.owner
				console.log "before owner is #{beforeOwner}"
				inventoryObj.transfer_from = beforeOwner 
				inventoryObj.owner = owner
				inventoryObj.addInventory_history history
				inventoryObj.save()

		# if change type
		if type? and inventoryObj.type.type_name != type
			models.type.findOrCreate { where: {type_name : type}, defaults: {type_name: type, creator: user_name}
			.spread (typeObj, isCreatedType) ->

				typeObj.addInventory inventoryObj

				# if change brand
				if brand? and inventoryObj.brand.brand_name != brand
					models.brand.findOrCreate { where: {brand_name : brand}, defaults : {brand_name : brand, creator: user_name}}
					.spread (brandObj, isCreatedBrand) ->

						brandObj.addInventory inventoryObj

						if isCreatedType
							brandObj.addType typeObj

						# if change category
						if category? and inventoryObj.category.category_name != category
							models.category.findOrCreate { where : { category_name : category}, defaults : {category_name: category, creator: user_name}}
							.spread (categoryObj, isCreatedCategory) ->

								categoryObj.addInventory inventoryObj

								if isCreatedBrand
									categoryObj.addBrand brandObj
						
						else if isCreatedBrand
								inventoryObj.category.addBrand brandObj

				else if isCreatedType
						inventoryObj.brand.addType typeObj

		inventoryObj.save()
		.then () ->
			res.json {"state": "OK", "code" : 0}


###
delete specified inventory by id
###
s.delete (req, res) ->
	res.json {"state": "delete OK"}


t = router.route '/:key/:value'
###
show inventory by field name and value
###
t.get (req, res) ->
	models = sqz.models
	models.inventory.find { where: {"#{req.params.key}" : req.params.value}, include: [models.category, models.brand, models.type]}
	.then (inventories) ->
		res.json inventories

module.exports = router