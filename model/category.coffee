# category.coffee
module.exports = (sequelize, DataTypes) ->
  category = sequelize.define 'category', {
    id: {
      type: DataTypes.INTEGER,
      allowNull: false,
      primaryKey: true,
      autoIncrement: true
    },
    category_name: {
      type: DataTypes.STRING,
      allowNull: true
    },
    creator: {
      type: DataTypes.STRING,
      allowNull: true
    }
  }