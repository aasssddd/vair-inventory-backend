# inventory.coffee

express = require 'express'
router = express.Router()
{sqz} = require './persistence/database'

# GET users listing.
router.route '/inventory'
.get (req, res) ->
	res.json user

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