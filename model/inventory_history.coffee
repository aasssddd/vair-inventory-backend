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
    reason: {
      type: DataTypes.STRING,
      allowNull: true
    },
    status_before: {
      type: DataTypes.ENUM('NEW', 'USE', 'FIX', 'STORE', 'ELIMINATE'),
      allowNull: false
    },
    new_status: {
      type: DataTypes.ENUM('NEW', 'USE', 'FIX', 'STORE', 'ELIMINATE'),
      allowNull: false
    }
  }
