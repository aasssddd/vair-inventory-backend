module.exports = (sequelize, DataTypes) ->
  inventory = sequelize.define 'inventory', {
    id: {
      type: DataTypes.STRING,
      allowNull: false,
      primaryKey: true
    },
    sn: {
      type: DataTypes.STRING,
      allowNull: true
    },
    holder: {
      type: DataTypes.STRING,
      allowNull: true
    },
    owner: {
      type: DataTypes.STRING,
      allowNull: true
    },
    transfer_from: {
      type: DataTypes.STRING,
      allowNull: true
    },
    transfer_date: {
      type: DataTypes.DATE,
      allowNull: true,
      defaultValue: DataTypes.NOW
    }
  }

