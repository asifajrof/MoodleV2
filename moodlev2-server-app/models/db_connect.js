const Pool = require("pg").Pool;
require("dotenv").config();

const devConfig = {
  user: process.env.DB_USER,
  password: process.env.DB_PASSWORD,
  host: process.env.DB_HOST,
  database: process.env.DB_DATABASE,
  port: process.env.DB_PORT,
};

// const prodConfig = {
//     connectionString: process.env.DATABASE_URL,
//     ssl: {
//         rejectUnauthorized: false,
//     },
// };

// const pool = new Pool(
//     process.env.NODE_ENV === 'production' ? prodConfig : devConfig
// );
const pool = new Pool(devConfig);

module.exports = pool;
