module.exports = (sequelize, DataTypes) ->
  brand = sequelize.define 'brand', {
    id: {
      type: DataTypes.INTEGER,
      allowNull: false,
      primaryKey: true,
      autoIncrement: true
    },
    brand_name: {
      type: DataTypes.STRING,
      allowNull: true
    },
    creator: {
      type: DataTypes.STRING,
      allowNull: true
    }
  }



