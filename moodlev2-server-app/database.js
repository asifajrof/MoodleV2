const {Client} = require('pg');
const client = new Client ({
    host: "localhost",
    user: "postgres",
    port: "5432",
    password: "PostgreSQLPassword08031998",
    database : "moodle_v2"
});

client.connect();
dc=5;
client.query('select * from department where dept_code=$1',[dc],(err,res)=>{
    if(err)
    {
        console.log(err.message);
    }
    else
    {
        console.log(res.rows);
    }
    client.end;
})