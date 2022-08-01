import React, { useState, useEffect } from "react";
import { Link } from "react-router-dom";

const CourseAddForm = ({course})=>{
    const [deptList, setDeptList] = useState([]);
    var offering,offered,_year,batch,level,term,course_num;
    var course_name;
    const current_year=2022;
    const term_list = [
        {
            term_name:"January",
            term_num:1
        },
        {
            term_name:"July",
            term_num:2
        }
    ]
    const onSubmitAction  = (event) =>
    {
        // prevent def
        event.preventDefault();
        console.log(offering);
    }
    const handleChange  = () =>
    {

    }
    useEffect(() => {
        const fetchData = async () => {
            try {
                const response = await fetch(`/api/admin/dept_list/`);
                const jsonData = await response.json();
                setDeptList(jsonData.data);
            } catch (err) {
                console.log(err);
            }
        };
        fetchData();
    }, []);

    return (
        <form onSubmit={onSubmitAction}>
            <fieldset>
                <label>
                    <p>Choose the department of the course:</p>
                    <select name='offering'>
                    <option value="">--Please choose an option--</option>
                        {deptList.map((dept, index) =>(
                            <option key={index} value={dept.dept_code}>{dept.dept_shortname}</option>
                        ))}
                    </select>
                </label>
            </fieldset>
            <input type="submit" value="Submit" />
        </form>
        //     <label for="offering_dept">Choose the department of the course:</label>
        //     <select id="offering_dept" name={offering}>
        //         {deptList.map((dept) =>(
        //             <option value={dept.dept_code}>{dept.dept_shortname}</option>
        //         ))}
        //     </select>
        //     <label for="offered_depts">Choose the department to which the course is offered:</label>
        //     <select id="offered_depts" name={offering}>
        //         {deptList.map((dept) =>(
        //             <option value={dept.dept_code}>{dept.dept_shortname}</option>
        //         ))}
        //     </select>
        //     <label for="offering_year">Choose the offering year:</label>
        //     <select id="offering_year" name={_year}>
        //         {
        //             for(let i=current_year;i>1940;i--)
        //             {
        //                 <option value={i}>{i}</option>
        //             }
        //         }
        //     </select>
        //     <label for="batch">Choose the batch year:</label>
        //     <select id="batch" name={batch}>
        //         {
        //             for(let i=current_year;i>1940;i--)
        //             {
        //                 <option value={i}>{i}</option>
        //             }
        //         }
        //     </select>
        //     <label for="level">Choose level:</label>
        //     <select id="level" name={level}>
        //         {
        //             for(let i=1;i<=5;i++)
        //             {
        //                 <option value={i}>{i}</option>
        //             }
        //         }
        //     </select>
        //     <label for="term">Choose level:</label>
        //     <select id="term" name={term}>
        //         {term_list.map((term) =>(
        //             <option value={term.term_num}>{term.term_name}</option>
        //         ))}
        //     </select>
        //     <input type="number" id="quantity" name="quantity" min="0" max="99">
        //     <input type="submit">
        // </form>

    //     <form onSubmit={this.handleSubmit}>
    //     <label>
    //       Name:
    //       <input type="text" value={this.state.value} onChange={this.handleChange} />
    //     </label>
    //     <input type="submit" value="Submit" />
    //   </form>
    )
}

export default CourseAddForm;