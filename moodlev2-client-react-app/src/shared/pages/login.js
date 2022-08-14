import React, { useEffect, useState } from "react";
import { FormHelperText, TextField, Button } from "@mui/material";
import "./login.css";
import PropTypes from "prop-types";

const Login = ({ onLogin }) => {
  const [uName, setUName] = useState("");
  const [password, setPassword] = useState("");
  const [token, setToken] = useState({});

  const loginUser = async (credentials) => {
    try {
      const res = await fetch(`/api/login`, {
        method: "POST",
        headers: {
          "Content-type": "application/json",
        },
        body: JSON.stringify(credentials),
      });
      const data = await res.json();
      console.log(data);
      setToken({ type: data.type, id: credentials.uName });
      // setToken({ type: data.type, id: data.id });
      // return { type: data.type, id: data.id };
    } catch (err) {
      console.log(err);
      alert(err);
    }
  };

  useEffect(() => {
    onLogin(token);
  }, [token]);

  const onSubmitAction = (event) => {
    event.preventDefault();
    if (!uName) {
      alert("Please enter username");
      return;
    }

    // console.log("onSubmitAction");
    // console.log(uName, password);
    setUName("");
    setPassword("");

    // const token = await loginUser({ uName, password });
    // onLogin(token);
    loginUser({ uName, password });

    // onLogin("student");
    console.log("onSubmitAction end");
  };
  return (
    <div className="login__container">
      <div className="login__title">Login</div>
      <form onSubmit={onSubmitAction} className="login__centered">
        <TextField
          fullWidth
          type="text"
          id="uName-input"
          label="Username"
          variant="outlined"
          value={uName}
          onChange={(e) => setUName(e.target.value)}
        />
        <FormHelperText id="uName-input-helper-text">
          Enter your Username
        </FormHelperText>
        <br />
        <TextField
          fullWidth
          type="password"
          id="password-input"
          label="Password"
          variant="outlined"
          value={password}
          onChange={(e) => setPassword(e.target.value)}
        />
        <FormHelperText id="password-input-helper-text">
          Enter your password
        </FormHelperText>
        <br />
        <Button fullWidth type="submit" variant="outlined">
          Login
        </Button>
      </form>
    </div>
  );
};

Login.propTypes = {
  onLogin: PropTypes.func.isRequired,
};

export default Login;
