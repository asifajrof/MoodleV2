import React from "react";
import { NavLink } from "react-router-dom";

const MenuOption = ({ option }) => {
  return (
    <li>
      <NavLink to={option.link}>{option._name}</NavLink>
    </li>
  );
};
export default MenuOption;
