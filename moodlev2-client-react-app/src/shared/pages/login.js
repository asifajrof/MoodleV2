import React, { useState } from "react";
import { FormHelperText, TextField, Button } from "@mui/material";
import "./login.css";

const Login = ({ onLogin }) => {
  const [email, setEmail] = useState("");
  const [password, setPassword] = useState("");
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
    // onAddDept({ deptName, deptShortName, deptCode });
    onLogin("student");
    console.log("onSubmitAction end");
  };
  return (
    <div className="login__container">
      <div className="login__title">Login</div>
      <form onSubmit={onSubmitAction} className="centered">
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

export default Login;
