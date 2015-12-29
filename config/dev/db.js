// db.js
/*
	storage is sqllite only
*/
module.exports = {
	dialect: "mysql",
	storage: "",
	host: "localhost",
	db_name: "vair_inventory",
	user: "inventory",
	password: "P@ssw0rd",
	model_path: "./model",
	regenerate_schema: true	
}