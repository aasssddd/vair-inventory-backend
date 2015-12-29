# tag.coffee
module.exports = (sequelize, DataTypes) ->
  tags = sequelize.define 'tags', {
    id: {
    	type: DataTypes.INTEGER,
    	primaryKey: true,
    	autoIncrement: true
    },
    value: {
    	type: DataTypes.STRING,
    	allowNull: false
  	}
  }, {
  	comment: "table of all Tags"
  }
