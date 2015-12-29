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

# inventory belongs to one brand, one type, one category
mdl = sqz.models
mdl.brand.hasMany mdl.inventory
mdl.inventory.belongsTo mdl.brand
mdl.type.hasMany mdl.inventory
mdl.inventory.belongsTo mdl.type
mdl.category.hasMany mdl.inventory
mdl.inventory.belongsTo mdl.category

# inventory_history belongs to one inventory
mdl.inventory.hasMany mdl.inventory_history

# one category has many brands, one brands has many category
mdl.category.belongsToMany mdl.brand, {through: "category_brand"}
mdl.brand.belongsToMany mdl.category, {through: "category_brand"}

# one brand has many type, one type maybe belongs to many brand
mdl.brand.belongsToMany mdl.type, {through: "brand_type"}
mdl.type.belongsToMany mdl.brand, {through: "brand_type"}


# tagging to category
mdl.tags.belongsToMany mdl.category, {through: "category_tag"}
mdl.category.belongsToMany mdl.tags, {through: "category_tag"}

# tagging to brand
mdl.tags.belongsToMany mdl.brand, {through: "brand_tag" }
mdl.brand.belongsToMany mdl.tags, {through: "brand_tag" }

# tagging to type
mdl.type.belongsToMany mdl.tags, {through: "type_tag" }
mdl.category.belongsToMany mdl.tags, {through: "category_tag" }

# tagging to inventory
mdl.inventory.belongsToMany mdl.tags, {through: "inventory_tag"}
mdl.tags.belongsToMany mdl.inventory, {through: "inventory_tag"}


sqz.sync({force: config.db.regenerate_schema})

module.exports = {sqz, Sequelize}
