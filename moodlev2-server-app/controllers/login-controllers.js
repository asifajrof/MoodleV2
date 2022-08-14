const pool = require("../models/db_connect");
const HttpError = require("../models/http-error");
const { compare } = require("bcryptjs");

const loginAuthenticate = async (req, res, next) => {
  try {
    // console.log("inside login authentication");
    const { uName, password } = req.body;
    let result = await pool.query(
      "SELECT json_agg(t) FROM get_account_type($1) as t",
      [uName]
    );
    const user = result.rows[0].json_agg;
    // console.log(user);
    // console.log(result);
    if (!user) {
      console.log("user not found");
      next(new HttpError("User not found", 404));
    } else {
      console.log(password, user[0].hashed_password);
      const validPassword = await compare(password, user[0].hashed_password);
      console.log(validPassword);
      if (!validPassword) {
        return next(new HttpError("wrong password", 404));
      }

      res.json({
        type: user[0].type,
        id: user[0].id,
        token: process.env.SECRET_TOKEN,
      });
    }
  } catch (err) {
    return next(new HttpError(err.message, 500));
  }
};

exports.loginAuthenticate = loginAuthenticate;
