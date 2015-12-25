express = require 'express'
{sqz, Sequelize} = require '../persistence/database'
tosource = require 'to-source'
router = express.Router()


# GET users listing.
router.route '/users'
.get (req, res) ->
	models = sqz.models
	sqz.transaction (t) ->
		models.brand.findOrCreate { where: {brand_name: "ASUS"}, defaults: {creator: "William Chen"}}
		.spread (brand, created) ->
			brandObj = if brand? then brand else created
			models.type.findOrCreate {where: {type_name: "X555L"}, defaults: {creator: "William Chen"}}
			.spread (type, created) ->
				typeObj = if type? then type else created
				models.inventory.findOrCreate {where: {id: "2014000707"}, defaults: {sn: "ECN0CV484272516", holder: "William Chen", owner: "William Chen"}}
				.spread (inventory, created) ->
					inventoryObj = if inventory? then inventory else created
					if not inventory?
						brandObj.setInventory inventoryObj
						typeObj.setInventory inventoryObj
					models.inventory_history.create { transfer_to: "William Chen", operator: "William Chen" }
					.then (history) ->
						inventoryObj.setInventory_history history
				
	res.json { "status": "OK"}

.post (req, res)->
	user.push req.body
	res.json {"state": "OK"}

router.route '/users/:id'
.put (req, res) ->
	res.json {"state":"Update OK"}

.get (req, res)->
	res.json user[req.params.id]

.delete (req, res) ->
	res.json {"state": "delete OK"}

module.exports = router
