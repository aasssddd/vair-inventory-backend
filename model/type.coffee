module.exports = (sequelize, DataTypes) ->
  type = sequelize.define 'type', {
    id: {
      type: DataTypes.INTEGER,
      allowNull: false,
      primaryKey: true,
      autoIncrement: true
    },
    type_name: {
      type: DataTypes.STRING,
      allowNull: true
    },
    creator: {
      type: DataTypes.STRING,
      allowNull: true
    }
  }
