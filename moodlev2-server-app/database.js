const {Client} = require('pg');
const client = new Client ({
    host: "localhost",
    user: "postgres",
    port: "5432",
    password: "PostgreSQLPassword08031998",
    database : "moodle_v2"
});
dc=1705119;
client.connect().then(
    client.query('select json_agg(t) FROM get_current_course($1) as t',[dc],(err,res)=>{
        if(err)
        {
            console.log(err.message);
        }
        else
        {
            res.rows.map((row,index)=>{
                // console.log(JSON.parse(row.json_agg));
                row.json_agg.map((r,idx)=>{

                    console.log(r);
                })
            })
            
        }
        client.end;
    })
);

