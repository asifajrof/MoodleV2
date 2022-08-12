import React, { useEffect, useState } from "react";
import { FormHelperText, TextField, Button } from "@mui/material";
import "./login.css";
import PropTypes from "prop-types";

const Login = ({ onLogin }) => {
  const [email, setEmail] = useState("");
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
      // console.log(data);
      setToken({ type: data.type, id: data.id });
      // return { type: data.type, id: data.id };
    } catch (err) {
      console.log(err);
      alert("Wrong credentials. Try again.");
    }
  };

  useEffect(() => {
    onLogin(token);
  }, [token]);

  const onSubmitAction = (event) => {
    event.preventDefault();
    if (!email) {
      alert("Please enter email");
      return;
    }

    console.log("onSubmitAction");
    console.log(email, password);
    setEmail("");
    setPassword("");

    // const token = await loginUser({ email, password });
    // onLogin(token);
    loginUser({ email, password });

    // onLogin("student");
    console.log("onSubmitAction end");
  };
  return (
    <div className="login__container">
      <div className="login__title">Login</div>
      <form onSubmit={onSubmitAction} className="login__centered">
        <TextField
          fullWidth
          type="email"
          id="email-input"
          label="E-mail Address"
          variant="outlined"
          value={email}
          onChange={(e) => setEmail(e.target.value)}
        />
        <FormHelperText id="email-input-helper-text">
          Enter your email address
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
        <FormHelperText id="email-input-helper-text">
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
