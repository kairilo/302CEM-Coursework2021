const fs = require('fs');
const mysql = require('mysql');

const con3021st = mysql.createConnection({
    host: 'localhost',
    port: 3306,
    user: 'root',
    password: '',
    database: '3021st'
});
const con302second = mysql.createConnection({
    host: 'localhost',
    port: 3306,
    user: 'root',
    password: '',
    database: '302second'
});


~async function init() {    //Wrap everything into 1 single program for the sake of async function
    const firstpart = () => {   //Assign the function to a variable to better make use of "async" and "await" function
        return new Promise(resolve => {
            con3021st.connect( function (err) {
                if (err) throw err;
                con3021st.query('select * from `head`', function (err, results) {   //Select all data from db
                    if (err) throw err;
                    fs.writeFile('302.json', JSON.stringify(results, null, 2), function (err) { //Create a json file with the data selected
                        if (err) throw err;
                        console.log('A new file "302.json" is created in the current directory!');
                        resolve();  //Return the promise as revolved and and its purpose is fulfilled, the code below "await" can be executed
                    });
                    con3021st.end();
                });
            })
        });
    };
    console.log('Starting the process "SQL2JSON"...') //Separate 2 parts of this async function
    await firstpart();  //Make sure the firstpart() is correctly executed before moving onto the next part of the function
    console.log('Preparing to upload the json file onto the new database...')   //Separate 2 parts of this async function
    con302second.connect(function (err) {
        if (err) throw (err);
        fs.readFile('302.json', (error, data) => {
            if (error) throw error;
            var obj = JSON.parse(data); //Turn the data extracted into javascript object
            var query = 'INSERT INTO `head` (`head1`,`head2`,`head3`) VALUES (?,?,?)';  //Edit this according to different needs
            var count = 0; //For counting how many cells inserted / How many times did the following loop repeat
            for (var objorder = 0; objorder < obj.length; objorder++) { //For each object in the [] list waiting to be inserted
                var time = 0;   //To assign different objects' values in the [] into different variables according to the number generated
                for (let values in obj[objorder]) { //Assign "values" of the {object} of the [list] to variables
                    if (time === 0) {   //First Column
                        var first = (obj[objorder][values]);
                        time++;
                    }
                    else if (time === 1) {  //Second Column
                        var second = (obj[objorder][values]);
                        time++;
                    }
                    else if (time === 2) {  //Third column
                        var third = (obj[objorder][values]);
                        time++;
                    }
                    count += 1;
                }   //Create more variables for more known columns
                //If there are 5 columns waiting to be inserted / 5 cells per row, there should be 5 variables used to store the object value
                con302second.query(query, [first, second, third], function (err) {
                    if (err) throw err;
                });
            };
            console.log(obj.length + ' rows and a total of ' + count + ' cells are successfully Inserted!');
            con302second.end();
        });
    });
}();
//The expected outcome from the terminal is as follow:
                        // EXAMPLE//
//Starting the process "SQL2JSON"...
//A new file "File Name.json" is created in the current directory!
//Preparing to upload the json file onto the new database...
//X rows and a total of X cells are successfully inserted!
                        //EXAMPLE//
//If the actualy outcome order is somehow different from the above, the code is executing incorrectly.

