# database.coffee
Sequelize = require 'sequelize'
config = require 'app-config'
path = require 'path'
fs = require 'fs'
cls = require 'continuation-local-storage'
namespace = cls.createNamespace 'test-space'
Sequelize.cls = namespace

sqz = new Sequelize config.db.db_name, config.db.user, config.db.password, {
	dialect: config.db.dialect
	host: config.db.host
	storage: config.db.storage
	define: {
		freezeTableName: true
	}
}

model_path = config.db.model_path

files = fs.readdirSync model_path
models = files.filter (f_name)->
	return f_name.indexOf ".coffee"

models.forEach (obj)->
	module.exports[obj] = sqz.import ((path.resolve model_path, obj).replace /\.coffee/, "")

#relation 
sqz.models.brand.hasOne sqz.models.inventory
sqz.models.type.hasOne sqz.models.inventory
sqz.models.inventory.hasOne sqz.models.inventory_history

sqz.sync({force: true})

module.exports = {sqz, Sequelize}
