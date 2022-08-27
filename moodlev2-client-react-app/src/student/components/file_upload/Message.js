import React from "react";
import PropTypes from "prop-types";

const Message = ({ msg, showVal }) => {
  // const [show, setShow] = React.useState(showVal);
  // console.log("arekbar call hoise", show);
  // console.log("arekbar call hoise", msg);
  return (
    <div style={{ height: "100%" }}>
      {msg !== "" && (
        <div
          className="alert alert-info alert-dismissible fade show"
          role="alert"
        >
          {msg}
          <button
            type="button"
            onClick={() => {
              // console.log("kisui hoy na");
            }}
          ></button>
        </div>
      )}
    </div>
  );
};

Message.propTypes = {
  msg: PropTypes.string.isRequired,
};

export default Message;
