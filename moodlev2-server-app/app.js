const express = require('express');
const bodyParser = require('body-parser');

const studentRoutes = require('./routes/student-routes');
const HttpError = require('./models/http-error');

const {getCurrentCoursesById} = require('./models/db_getCurrentCoursesById');

const app = express();
app.use(bodyParser.json());
const PORT = process.env.PORT || 5000;
app.listen(PORT);

app.get("/api/:studentId", async (req,res)=>{
    // res.json({"users":["userOne","userTwo","userThree"]})
    const studentId = parseInt(req.params.studentId);
    console.log(typeof studentId);
    console.log('studentId: ' + studentId);
    const someVar = await getCurrentCoursesById(studentId);
    console.log('print it ', someVar);
    res.json(someVar);
})

app.use('/api/student',studentRoutes);

app.use((req, res, next) => {
    const error = new HttpError('Could not find this route.', 404);
    next(error);
});

// default error handler
app.use((error, req, res, next) => {
    if (res.headerSent){
        return next(error);
    }
    res.status(error.status || 500);
    res.json({message: error.message || 'An unknown error occurred!'});
});


console.log(`Server listening on port ${PORT}`);
