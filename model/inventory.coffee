module.exports = (sequelize, DataTypes) ->
  inventory = sequelize.define 'inventory', {
    id: {
      type: DataTypes.INTEGER,
      allowNull: false,
      autoIncrement: true,
      primaryKey: true
    },
    assetId: {
      type: DataTypes.STRING,
      allowNull: true,
      unique: true
    },
    sn: {
      type: DataTypes.STRING,
      allowNull: true,
      unique: true
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
    }, 
    status: {
      type: DataTypes.ENUM('NEW', 'USE', 'FIX', 'STORE', 'ELIMINATE'),
      allowNull: false,
      defaultValue: 'NEW'
    }
  }

