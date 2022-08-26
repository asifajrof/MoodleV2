import React, { useState, useEffect } from "react";
// import { Link } from "react-router-dom";
import { styled } from "@mui/material/styles";
import Table from "@mui/material/Table";
import TableBody from "@mui/material/TableBody";
import TableCell, { tableCellClasses } from "@mui/material/TableCell";
import TableContainer from "@mui/material/TableContainer";
import TableHead from "@mui/material/TableHead";
import TableRow from "@mui/material/TableRow";
import Paper from "@mui/material/Paper";
import Checkbox from "@mui/material/Checkbox";

import CourseCRTableRow from "./CourseCRTableRow";

// import './registered_course.css';

const StyledTableCell = styled(TableCell)(({ theme }) => ({
  [`&.${tableCellClasses.head}`]: {
    //   backgroundColor: theme.palette.common.black,
    backgroundColor: "#F4F7FC",
    color: theme.palette.common.black,
    fontWeight: "bold",
  },
  [`&.${tableCellClasses.body}`]: {
    fontSize: 14,
  },
}));

const CourseCRTable = ({ adminNo, courseId }) => {
  const [selectedCRsList, setSelectedCRsList] = useState([]);
  const [courseCRsList, setCourseCRsList] = useState([]);
  const [checkedList, setCheckedList] = useState([]);
  const [showDelete, setShowDelete] = useState(false);

  const handleChangeCheckAll = (event) => {
    const newCheckedList = [...checkedList];
    const newSelectedCRsList = [];
    if (event.target.checked === true) {
      // add all into selected
      for (let i = 0; i < courseCRsList.length; i++) {
        newCheckedList[i] = true;
        newSelectedCRsList.push({
          index: i,
          crObj: courseCRsList[i],
        });
      }
    } else {
      // remove all from selected
      for (let i = 0; i < courseCRsList.length; i++) {
        newCheckedList[i] = false;
      }
    }
    setCheckedList(newCheckedList);
    setSelectedCRsList(newSelectedCRsList);
  };
  const isAllChecked = () => {
    let val = false;
    // for loop
    for (let i = 0; i < checkedList.length; i++) {
      if (checkedList[i] === false) {
        val = false;
        break;
      } else {
        val = true;
      }
    }
    return val;
  };
  const isIndeterminate = () => {
    let val = false;
    let initial = false;
    // for loop
    for (let i = 0; i < checkedList.length; i++) {
      if (i === 0) {
        initial = checkedList[i];
      } else {
        if (checkedList[i] !== initial) {
          val = true;
          break;
        }
      }
    }
    return val;
  };

  const handleChangeSingle = (index, checked) => {
    const newCheckedList = [...checkedList];
    newCheckedList[index] = checked;
    setCheckedList(newCheckedList);

    const newSelectedCRsList = [...selectedCRsList];
    if (checked === true) {
      // insert into selectedCRsList
      newSelectedCRsList.push({
        index: index,
        crObj: courseCRsList[index],
      });
    } else {
      // remove from selectedCRsList after finding
      // find
      const foundIndex = newSelectedCRsList.findIndex(
        (selectedCR) => selectedCR.index === index
      );
      // remove
      newSelectedCRsList.splice(foundIndex, 1);
    }
    setSelectedCRsList(newSelectedCRsList);
  };

  useEffect(() => {
    const fetchData = async () => {
      try {
        // fetch change hobe
        const response = await fetch(`/api/admin/students/all`);
        const jsonData = await response.json();
        setCourseCRsList(jsonData.data);
        // create courseCRsList.length array filled with false
        const newCheckedList = new Array(jsonData.data.length).fill(false);
        setCheckedList(newCheckedList);
        // console.log(jsonData.data);
      } catch (err) {
        console.log(err);
      }
    };
    fetchData();
  }, []);

  useEffect(() => {
    setShowDelete(selectedCRsList.length > 0);
  }, [selectedCRsList]);
  return (
    <>
      {showDelete && <div style={{ alignSelf: "flex-start" }}>button here</div>}
      <div style={{ width: "100%", paddingRight: "4rem" }}>
        <TableContainer component={Paper}>
          <Table sx={{ minWidth: 700 }} aria-label="customized table">
            <TableHead>
              <TableRow>
                {/* <StyledTableCell align="center"> </StyledTableCell> */}
                <StyledTableCell align="center">
                  <Checkbox
                    checked={isAllChecked()}
                    indeterminate={isIndeterminate()}
                    onChange={handleChangeCheckAll}
                  />
                </StyledTableCell>
                <StyledTableCell align="center">Name</StyledTableCell>
                <StyledTableCell align="center">Username</StyledTableCell>
                <StyledTableCell align="center">E-mail</StyledTableCell>
                <StyledTableCell align="center">Department</StyledTableCell>
                {/* <StyledTableCell align="center">Designation</StyledTableCell> */}
              </TableRow>
            </TableHead>
            <TableBody>
              {courseCRsList.map((crObj, index) => (
                <CourseCRTableRow
                  key={index}
                  crIndex={index}
                  checked={
                    checkedList[index] === undefined
                      ? false
                      : checkedList[index]
                  }
                  crObj={crObj}
                  adminNo={adminNo}
                  courseId={courseId}
                  handleChangeSingle={handleChangeSingle}
                />
              ))}
            </TableBody>
          </Table>
        </TableContainer>
      </div>
    </>
  );
};

export default CourseCRTable;
