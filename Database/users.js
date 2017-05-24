var fs = require("fs")

var users = {}
var fall_sum = 0.0
var spring_sum = 0.0
var fall_count = 0.0
var spring_count = 0.0
var summmer_sum = 0.0
var summer_count = 0.0
var term_number = 1


fs.readFile("_User.json", 'utf8', function(err, data) {
    if (err) throw err;
    //console.log('OK: ' + filename);
    users = JSON.parse(data).results
    //console.log(users[2467])

    for(var i = 0; i < users.length; i++){

        try {
            var records = JSON.parse(users[i].records)
        }catch(e){
            console.log(users[i].records)
        }
        var username = users[i].username
        if (username=="bhiziroglu14") console.log(users[i].gpa) 


      for(var j in records){

        if(Object.keys(records[j]).length > 0){

            for (first in records[j]) break;
            //console.log(records[j])

            var example_term = records[j][first].term.split(" ")[0]
            //console.log(example_term)

            if(example_term == "Fall"){
                term_number = 1;
            }else if(example_term == "Spring"){
                term_number = 2;
            }else{
                term_number = 3;
            }


            var sum = 0.0;
            var number = 0;
            var units = 0.0;

            for(var k in records[j]){
                if(records[j][k].wunit != 0.0 && records[j][k].valid == 1){
                    sum += parseFloat(records[j][k].point)* parseFloat(records[j][k].wunit);
                    number++;
                    units += parseFloat(records[j][k].wunit);
                }
            }

            if(number != 0) {
                //sum = sum / units;
                if(term_number==1){
                    fall_count += units;
                    fall_sum  += sum
                }else if(term_number==2){
                    spring_count += units;
                    spring_sum  += sum
                }else{
                    summer_count += units;
                    summmer_sum += sum
                }
            }

         }
       }
    }


    console.log("fall_average=" + fall_sum/fall_count)
    console.log("spring_average=" + spring_sum/spring_count)
    console.log("summer_average=" + summmer_sum/summer_count)


});
