module.exports = (sequelize, DataTypes) ->
  inventory_history = sequelize.define 'inventory_history', {
    transfer_from: {
      type: DataTypes.STRING,
      allowNull: true
    },
    transfer_to: {
      type: DataTypes.STRING,
      allowNull: false
    },
    operator: {
      type: DataTypes.STRING,
      allowNull: false
    },
    transfer_date: {
      type: DataTypes.DATE,
      allowNull: false,
      defaultValue: DataTypes.NOW,
      primaryKey: true,
    }
  }
