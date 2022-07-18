const {Client} = require('pg');
const client = new Client ({
    host: "localhost",
    user: "postgres",
    port: "5432",
    password: "1705092pgsql",
    database : "MoodleV2"
});

// const getCurrentCoursesById = (studentId) => {
//     let result;
//     console.log('db getCurrentCoursesById');
//     client.connect().then(() => {
//         console.log('Connected to database');
//         client.query('select json_agg(t) FROM get_current_course($1) as t',[studentId],(err,res)=>{
//             if(err)
//             {
//                 console.log(err.message);
//                 client.end;
//                 result = null;
//             }
//             else
//             {
//                 console.log('db function success case');
//                 result = res.rows[0].json_agg;
//                 client.end;
//                 console.log(result);
//                 console.log('db function after client end');
                
//             }
//         })
//     });
//     return result;
// };

// exports.getCurrentCoursesById = getCurrentCoursesById;


let result;
const studentId = 1705119;
console.log('db getCurrentCoursesById');
client.connect().then(() => {
    console.log('Connected to database');
    client.query('select json_agg(t) FROM get_current_course($1) as t',[studentId],(err,res)=>{
        if(err)
        {
            console.log(err.message);
            client.end;
            result = null;
        }
        else
        {
            console.log('db function success case');
            result = res.rows[0].json_agg;
            client.end;
            console.log(result);
            console.log('db function after client end');
            
        }
    })
});
